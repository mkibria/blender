
uniform sampler1D weightTex;

in vec3 pos;
in float weight;

out vec4 finalColor;

#define no_active_weight 666.0

vec3 weight_to_rgb(float t)
{
  if (t == no_active_weight) {
    /* No weight. */
    return colorWire.rgb;
  }
  if (t > 1.0 || t < 0.0) {
    /* Error color */
    return vec3(1.0, 0.0, 1.0);
  }
  else {
    return texture(weightTex, t).rgb;
  }
}

void main()
{
  GPU_INTEL_VERTEX_SHADER_WORKAROUND

  finalColor = vec4(weight_to_rgb(weight), 1.0);

  vec3 world_pos = point_object_to_world(pos);
  gl_Position = point_world_to_ndc(world_pos);

#ifdef USE_WORLD_CLIP_PLANES
  world_clip_planes_calc_clip_distance(world_pos);
#endif
}
