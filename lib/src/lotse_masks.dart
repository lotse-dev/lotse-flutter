import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

// Masks in the image, not on the screen, see `docs/REPLAY.md`, "Maskierung im
// Bild statt auf dem Bildschirm". The regions are read from the render tree
// right before the boundary is rasterised, so image and masks belong to the
// same frame, and painted into the image before it is encoded. The screen
// never changes, and no unmasked image is ever encoded.

/// Why a region is masked.
enum LotseMaskKind {
  /// A `LotseConfidential` region. Wins over `LotseUnmasked`.
  confidential,

  /// A text input, masked unless inside `LotseUnmasked`.
  textInput,

  /// A platform view (web view, map) outside `LotseUnmasked`.
  platformView,

  /// A platform view inside `LotseUnmasked` that Flutter cannot draw into the
  /// image: Hybrid Composition, iOS, web. Only texture-based Android views
  /// are in it, see [isRecordablePlatformView] and `docs/REPLAY.md`, "Platform
  /// Views".
  unrecordable,

  /// Any text, with `LotseScope(maskAllText: true)`.
  text,
}

/// A region to black out, in logical pixels of the boundary.
typedef LotseMask = ({Rect rect, LotseMaskKind kind});

/// Marks the render object of `LotseConfidential`.
abstract interface class LotseConfidentialMarker {}

/// Marks the render object of `LotseUnmasked`.
abstract interface class LotseUnmaskedMarker {}

/// The regions of [boundary] to mask: confidential regions, text inputs and
/// platform views outside `LotseUnmasked`, platform views inside it that
/// cannot be recorded, and with [maskAllText] every text.
///
/// Walks what is painted and, when unsure, searches (`_searchChildren`).
/// Each region is cut to the clips above it (scroll views, clip widgets), so
/// a text field scrolled out of its list does not black out the app bar. A
/// masked region is not searched further.
///
/// Under an active image filter a region covers the whole filtered box: a
/// shader moves pixels without the render tree knowing, like the Android
/// stretch overscroll under Impeller (F8 in `docs/PLAN.md`).
List<LotseMask> collectLotseMasks(
  RenderObject boundary, {
  bool maskAllText = false,
}) {
  final masks = <LotseMask>[];
  final bounds = boundary is RenderBox && boundary.hasSize
      ? Offset.zero & boundary.size
      : Rect.largest;

  Rect rectOf(RenderBox box) => MatrixUtils.transformRect(
    box.getTransformTo(boundary),
    Offset.zero & box.size,
  );

  // [filtered] is the box of the outermost active image filter above, the
  // area its pixels may end up in.
  void visit(RenderObject node, Rect clip, bool unmasked, Rect? filtered) {
    if (node is RenderBox && node.hasSize) {
      if (filtered == null && _filtersImage(node)) {
        filtered = rectOf(node).intersect(clip);
      }
      final kind = switch (node) {
        LotseConfidentialMarker() => LotseMaskKind.confidential,
        PlatformViewRenderBox() || RenderDarwinPlatformView() when unmasked =>
          isRecordablePlatformView(node) ? null : LotseMaskKind.unrecordable,
        _ when unmasked => null,
        RenderEditable() => LotseMaskKind.textInput,
        PlatformViewRenderBox() ||
        RenderDarwinPlatformView() => LotseMaskKind.platformView,
        RenderParagraph() when maskAllText => LotseMaskKind.text,
        _ => null,
      };
      if (kind != null) {
        final rect = rectOf(node).intersect(clip);
        if (rect.isEmpty) return;
        final cover = filtered ?? rect;
        if (!cover.isEmpty) masks.add((rect: cover, kind: kind));
        return;
      }
      if (_clips(node)) clip = rectOf(node).intersect(clip);
      if (clip.isEmpty) return;
    }
    final inner = unmasked || node is LotseUnmaskedMarker;
    _searchChildren(node, (child) => visit(child, clip, inner, filtered));
  }

  visit(boundary, bounds, false, null);
  return masks;
}

/// Calls [visitor] on the children of [node] that may be painted. Fails
/// closed: a child is left out only where Flutter is known not to paint it.
///
/// A node with one child (proxies, shifted boxes, sliver adapters) passes it
/// on unless it is known not to paint it, see [_paintsChild]. Semantics is
/// no guide here: `ExcludeSemantics`, `Semantics(excludeSemantics: true)`
/// (date and time pickers, `CupertinoNavigationBar`) and `IgnorePointer`,
/// `AbsorbPointer` and `SliverIgnorePointer` with `ignoringSemantics` hide
/// children from semantics that are on the screen.
///
/// A node with several children passes on those `visitChildrenForSemantics`
/// visits. In Flutter 3.47 the overrides that skip children all skip
/// unpainted ones: offstage overlay entries and the routes under an opaque
/// one, the hidden children of an `IndexedStack`, kept-alive items of lists
/// and tables, slivers outside the viewport and its cache extent, pages of a
/// `PageView` out of view, the overflow items of the text selection toolbars,
/// the measuring children of `DropdownMenu`.
/// The one exception is the hint of an `InputDecorator`: skipped in an
/// unfocused field with a label, painted there with
/// `FloatingLabelBehavior.always`. It is app text, not user input, and
/// covered by the mask of the input it sits on.
void _searchChildren(RenderObject node, RenderObjectVisitor visitor) {
  if (node case RenderObjectWithChildMixin(:final child?)) {
    if (_paintsChild(node)) visitor(child);
  } else {
    node.visitChildrenForSemantics(visitor);
  }
}

/// Whether [node] paints its child, by the conditions of the `paint` methods
/// in Flutter 3.47: not offstage, not an opacity that rounds to alpha 0.
/// These are the cases where semantics skips the child as well, unless
/// `alwaysIncludeSemantics` keeps a transparent one there. Not
/// `paintsChild`: the sliver variants do not override it.
///
/// Anything else counts as painted. That masks too much in one case: a
/// `Visibility` or `SliverVisibility` that is hidden but keeps its size has a
/// private render object, so its subtree is masked although it is not drawn.
bool _paintsChild(RenderObject node) => switch (node) {
  RenderOffstage(:final offstage) ||
  RenderSliverOffstage(:final offstage) => !offstage,
  RenderOpacity(:final opacity) ||
  RenderSliverOpacity(:final opacity) => _alpha(opacity) > 0,
  RenderAnimatedOpacityMixin(:final opacity) => _alpha(opacity.value) > 0,
  _ => true,
};

int _alpha(double opacity) => ui.Color.getAlphaFromOpacity(opacity);

/// Whether [node] is a platform view Flutter draws itself, as a texture, and
/// that therefore appears in `toImage`: an Android view with Texture Layer
/// Hybrid Composition, the default of `AndroidView` and `webview_flutter`.
/// Hybrid Composition (also as a fallback the platform picks when the view
/// is created), iOS and web views are composited outside Flutter and missing
/// from the image. Found on the OnePlus in spike P1.
bool isRecordablePlatformView(RenderObject node) =>
    node is RenderAndroidView && !node.controller.requiresViewComposition;

/// Whether [box] paints its children through an image filter that may move
/// pixels (`ImageFiltered`, enabled). Such a box is a repaint boundary with
/// an [ImageFilterLayer]; the identity matrix changes nothing.
bool _filtersImage(RenderBox box) {
  if (!box.isRepaintBoundary) return false;
  // The layer is the only public trace of the filter; the render object of
  // `ImageFiltered` is private.
  // ignore: invalid_use_of_protected_member
  final layer = box.layer;
  if (layer is! ImageFilterLayer) return false;
  final filter = layer.imageFilter;
  return filter != null && filter != _identityFilter;
}

final _identityFilter = ui.ImageFilter.matrix(Matrix4.identity().storage);

/// Whether [box] cuts off what its children paint outside of it.
bool _clips(RenderBox box) => switch (box) {
  RenderViewportBase(:final clipBehavior) => clipBehavior != Clip.none,
  RenderClipRect(:final clipBehavior) ||
  RenderClipRRect(:final clipBehavior) ||
  RenderClipOval(:final clipBehavior) ||
  RenderClipPath(:final clipBehavior) => clipBehavior != Clip.none,
  _ => false,
};

/// Colour of a mask in the image. Platform views are grey, so the console
/// can tell "could not be recorded" from "hidden on purpose".
ui.Color lotseMaskColor(LotseMaskKind kind) => switch (kind) {
  LotseMaskKind.platformView ||
  LotseMaskKind.unrecordable => const ui.Color(0xFF9E9E9E),
  _ => const ui.Color(0xFF000000),
};

/// The label under the symbol of an [LotseMaskKind.unrecordable] region.
/// English, like the console that shows the image.
const lotseUnrecordableLabel = 'Not recordable';

const _symbolColor = ui.Color(0xFF616161);

/// [image] with [masks] painted over it, at [pixelRatio] pixels per logical
/// pixel. Disposes [image]; the caller owns the result.
Future<ui.Image> paintLotseMasks(
  ui.Image image,
  List<LotseMask> masks,
  double pixelRatio,
) async {
  if (masks.isEmpty) return image;
  final picture = _maskedPicture(image, masks, pixelRatio);
  try {
    return await picture.toImage(image.width, image.height);
  } finally {
    picture.dispose();
    image.dispose();
  }
}

/// [paintLotseMasks] without waiting, for the replay recorder, which takes
/// its frame right after Flutter drew it.
ui.Image paintLotseMasksSync(
  ui.Image image,
  List<LotseMask> masks,
  double pixelRatio,
) {
  if (masks.isEmpty) return image;
  final picture = _maskedPicture(image, masks, pixelRatio);
  try {
    return picture.toImageSync(image.width, image.height);
  } finally {
    picture.dispose();
    image.dispose();
  }
}

ui.Picture _maskedPicture(
  ui.Image image,
  List<LotseMask> masks,
  double pixelRatio,
) {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  canvas.drawImage(image, Offset.zero, ui.Paint());
  final paint = ui.Paint()..isAntiAlias = false;
  for (final mask in masks) {
    final r = mask.rect;
    paint.color = lotseMaskColor(mask.kind);
    // Outwards to whole pixels, so no edge of the region shows.
    final rect = Rect.fromLTRB(
      (r.left * pixelRatio).floorToDouble(),
      (r.top * pixelRatio).floorToDouble(),
      (r.right * pixelRatio).ceilToDouble(),
      (r.bottom * pixelRatio).ceilToDouble(),
    );
    canvas.drawRect(rect, paint);
    if (mask.kind
        case LotseMaskKind.platformView || LotseMaskKind.unrecordable) {
      canvas.save();
      canvas.clipRect(rect);
      _paintPlatformViewSign(
        canvas,
        rect,
        pixelRatio,
        label: mask.kind == LotseMaskKind.unrecordable,
      );
      canvas.restore();
    }
  }
  return recorder.endRecording();
}

/// A window symbol in the middle of a platform view's region, and with
/// [label] [lotseUnrecordableLabel] under it. Left out where the region is
/// too small to read them; the grey alone still says "platform view".
void _paintPlatformViewSign(
  ui.Canvas canvas,
  Rect rect,
  double pixelRatio, {
  required bool label,
}) {
  final side = math.min(rect.width, rect.height) / pixelRatio;
  if (side < 24) return;
  final symbol = math.min(32.0, side / 2) * pixelRatio;
  final text = label ? _labelParagraph(rect.width, pixelRatio) : null;
  final gap = 8 * pixelRatio;
  final fits = text != null && symbol + gap + text.height <= rect.height;
  final height = fits ? symbol + gap + text.height : symbol;
  final top = rect.center.dy - height / 2;
  final window = Rect.fromCenter(
    center: Offset(rect.center.dx, top + symbol / 2),
    width: symbol,
    height: symbol * 0.8,
  );
  final stroke = ui.Paint()
    ..color = _symbolColor
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = math.max(1, symbol / 14);
  canvas.drawRRect(
    RRect.fromRectAndRadius(window, Radius.circular(symbol / 8)),
    stroke,
  );
  final bar = window.top + window.height / 4;
  canvas.drawLine(Offset(window.left, bar), Offset(window.right, bar), stroke);
  if (fits) {
    canvas.drawParagraph(text, Offset(rect.left, top + symbol + gap));
  }
}

ui.Paragraph _labelParagraph(double width, double pixelRatio) {
  final builder =
      ui.ParagraphBuilder(
          ui.ParagraphStyle(
            textAlign: TextAlign.center,
            fontSize: 12 * pixelRatio,
            maxLines: 1,
            ellipsis: '…',
          ),
        )
        ..pushStyle(ui.TextStyle(color: _symbolColor))
        ..addText(lotseUnrecordableLabel);
  return builder.build()..layout(ui.ParagraphConstraints(width: width));
}
