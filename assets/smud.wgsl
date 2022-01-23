#import bevy_smud::prelude
#import bevy_smud::shapes
#import bevy_smud::colorize

// Import the standard 2d mesh uniforms and set their bind groups

#import bevy_sprite::mesh2d_view_bind_group
[[group(0), binding(0)]]
var<uniform> view: View;

#import bevy_sprite::mesh2d_struct
[[group(1), binding(0)]]
var<uniform> mesh: Mesh2d;

// as specified in `specialize()`
struct Vertex {
    [[location(0)]] position: vec2<f32>;
    [[location(1)]] color: vec4<f32>;
};

struct VertexOutput {
    [[builtin(position)]] clip_position: vec4<f32>;
    [[location(0)]] color: vec4<f32>;
    [[location(1)]] pos: vec2<f32>;
};

[[stage(vertex)]]
fn vertex(vertex: Vertex) -> VertexOutput {
    var out: VertexOutput;
    // Project the world position of the mesh into screen position
    let pos = vertex.position * 30.;
    out.clip_position = view.view_proj * mesh.model * vec4<f32>(pos, 0.0, 1.0);
    out.color = vertex.color;
    out.pos = pos;
    return out;
}

struct FragmentInput {
    [[location(0)]] color: vec4<f32>;
    [[location(1)]] pos: vec2<f32>;
};

[[stage(fragment)]]
fn fragment(in: FragmentInput) -> [[location(0)]] vec4<f32> {
    let d = sd_circle(in.pos, 10.0);
    return colorize_normal(d, 0., in.color.rgb);
    // return in.color * length(in.pos) / 200.0;
}