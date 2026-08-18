# FuFu Look-Direction Mechanics

FuFu is a flat pixel-art Siamese kitten: cream/tan body, dark-brown points on ears, face mask, paws, and tail, small pink nose, and bright blue pixel eyes with white highlights. The style is crisp pixel art; the face is painted on a flat head surface.

## Natural gaze mechanism (what leads / what follows)

- **Primary gaze driver: the eyes.** FuFu's eyes are flat pixel eyes painted on the head surface, so the pupils and highlights slide within the fixed eye apertures as the gaze shifts. Keep the eye whites/apertures the same size and shape; only the drawn pupils/highlights move inside them.
- **Head and face follow the eyes.** The head turns slightly in the gaze direction: for left/right directions the face mask and nose tip cross to the corresponding side of the head center, and the near-side ear becomes slightly more visible while the far-side ear tucks behind the head silhouette.
- **Ears follow through.** The dark point ears tilt/rotate a few pixels with the head turn; they never detach and never cross the silhouette.
- **Upper body stays planted.** Paws, feet, and lower torso remain on the same baseline and at the same scale in every direction. Only the head/face/eyes and a subtle shoulder/neck shift express direction.
- **Tail counter-balances subtly.** The tail may shift a couple of pixels opposite the gaze for a grounded feel, but it must stay attached and inside the cell.
- **No whole-sprite rotation, skew, or tilt.** Direction is expressed through feature/head placement, never by rotating or deforming the entire sprite.

## Cardinal pose families

- **000 (up):** face broadly frontal; pupils and highlights at the TOP of the eye apertures; head tilts back a couple of pixels; ears point slightly more upward; body and baseline unchanged.
- **090 (screen-right):** pupils slide to the right side of the eye apertures; head turns right so the nose tip and face mask move to the viewer-right of the head center; right ear more visible, left ear partially tucks; subtle rightward shoulder shift.
- **180 (down):** face broadly frontal; pupils and highlights at the BOTTOM of the eye apertures; head dips forward a couple of pixels; ears tilt slightly forward/down; body and baseline unchanged.
- **270 (screen-left):** mirror of 090 in feature placement — pupils slide left, head turns left so the nose tip and face mask move to the viewer-left of the head center; left ear more visible.

## Motion budget

Each 22.5-degree step moves the pupils by roughly 1-2 pixels and the head/ear by a couple of pixels — an even, continuous arc around the clock. No single adjacent pair makes a large jump, bend, scale change, or prop shift. The face construction, body height, baseline, and planted paws are identical in all 16 cells.

## Avoidances

No replacement/googly eyes, no eye-white repainting, no floating pupils, no detached features, no labels/arrows/degree text, no shadows/glows, no scenery, no whole-sprite rotation or tilt, no chroma-key colors inside the pet.
