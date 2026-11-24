
//
// shGunShipArenaImpact — Fragment Shader
//
// Crimson impact with distinct pink-white highlights.
// Preserves original animation and transparency.
//

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 source = texture2D(
        gm_BaseTexture,
        v_vTexcoord
    );

    // Perceived brightness
    float brightness = dot(
        source.rgb,
        vec3(0.299, 0.587, 0.114)
    );

    // White highlights have strong RGB values.
    // Yellow/orange pixels have much less blue.
    float whiteness = min(
        source.r,
        min(source.g, source.b)
    );

    // Beam-matching palette
    vec3 dark_crimson = vec3(
        0.42, 0.025, 0.085
    );

    vec3 main_crimson = vec3(
        1.0, 0.215, 0.333
    );

    vec3 pink_white = vec3(
        1.0, 0.804, 0.863
    );

    // Preserve darker details
    float body = smoothstep(
        0.12,
        0.82,
        brightness
    );

    vec3 result = mix(
        dark_crimson,
        main_crimson,
        body
    );

    // Only near-white source pixels become
    // the pale centre of the impact.
    float highlight = smoothstep(
        0.35,
        0.85,
        whiteness
    );

    result = mix(
        result,
        pink_white,
        highlight
    );

    gl_FragColor = vec4(
        result * v_vColour.rgb,
        source.a * v_vColour.a
    );
}
