from PIL import Image, ImageDraw

# 创建上传图标 (加号图标)
size = 96
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# 绘制圆形背景
draw.ellipse([8, 8, 88, 88], fill=(246, 118, 9, 255), outline=(200, 90, 0, 255), width=3)

# 绘制加号
# 横线
draw.rectangle([28, 44, 68, 52], fill=(255, 255, 255, 255))
# 竖线
draw.rectangle([44, 28, 52, 68], fill=(255, 255, 255, 255))

# 保存图标
img.save('entry/src/main/resources/base/media/ic_upload.png')

print("✅ 上传图标创建成功！")
print("📁 ic_upload.png - 橙色圆形背景 + 白色加号")
