// Godot 4 Shader Code for Circular Alpha Mask
shader_type canvas_item; // 指定这是一个用于 2D 元素的着色器

// Uniforms: 这些变量可以在 Inspector 面板中调整
uniform float circle_radius : hint_range(0.0, 0.707) = 0.5; // 圆形可见区域的半径 (0.0 到 0.5 对应从中心到边缘, 0.707 大约到角落)
uniform float fade_smoothness : hint_range(0.0, 0.5) = 0.05; // 边缘羽化（模糊）的平滑度，值越大边缘越模糊

void fragment() {
    // 获取原始纹理颜色
    vec4 original_color = texture(TEXTURE, UV);

    // 计算当前像素 UV 坐标到中心点 (0.5, 0.5) 的距离
    // UV 坐标范围是从 (0,0) 左上角到 (1,1) 右下角
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);

    // 计算 alpha 值
    // smoothstep(edge0, edge1, x) 函数:
    // 当 x <= edge0 时返回 0.0
    // 当 x >= edge1 时返回 1.0
    // 当 edge0 < x < edge1 时，在 0.0 和 1.0 之间平滑插值 (S 曲线)

    // 我们希望在半径内 alpha 为 1，在半径外 alpha 为 0
    // fade_start: 开始过渡的点（圆的边缘）
    // fade_end: 完全透明的点（圆边缘 + 羽化宽度）
    float fade_start = circle_radius;
    float fade_end = circle_radius + fade_smoothness;

    // 计算一个介于 0.0 (完全透明) 和 1.0 (完全不透明) 之间的因子
    // 当 dist < fade_start 时，smoothstep 返回 0，alpha_factor = 1.0
    // 当 dist > fade_end 时，smoothstep 返回 1，alpha_factor = 0.0
    // 在两者之间时，alpha_factor 从 1.0 平滑过渡到 0.0
    float alpha_factor = 1.0 - smoothstep(fade_start, fade_end, dist);

    // 将计算出的 alpha 因子乘以原始纹理的 alpha 值
    // 这样可以保留纹理本身的透明度
    COLOR = vec4(original_color.rgb, original_color.a * alpha_factor);
}