from PIL import Image, ImageDraw

# 创建滤镜图标 (调色板图标)
size = 96
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# 绘制圆形背景
draw.ellipse([8, 8, 88, 88], fill=(246, 118, 9, 255), outline=(200, 90, 0, 255), width=3)

# 绘制滤镜符号 (三个重叠的圆形)
# 第一个圆 (左上)
draw.ellipse([25, 25, 50, 50], outline=(255, 255, 255, 255), width=3)
# 第二个圆 (中间)
draw.ellipse([35, 35, 60, 60], outline=(255, 255, 255, 255), width=3)
# 第三个圆 (右下)
draw.ellipse([45, 45, 70, 70], outline=(255, 255, 255, 255), width=3)

# 保存图标
img.save('entry/src/main/resources/base/media/ic_filter.png')

print("✅ 滤镜图标创建成功！")
print("📁 ic_filter.png - 橙色圆形背景 + 白色滤镜符号")
