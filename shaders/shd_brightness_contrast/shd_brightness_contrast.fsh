varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_brightness;
uniform float u_contrast;

void main()
{
    vec4 col = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);

    col.rgb = (col.rgb - 0.5) * u_contrast + 0.5;
    col.rgb *= u_brightness;
    col.rgb = clamp(col.rgb, 0.0, 1.0);

    gl_FragColor = col;
}