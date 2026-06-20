from PIL import Image, ImageDraw

# 创建背景图层 - 黄色渐变背景
background = Image.new('RGBA', (216, 216), (255, 220, 0, 255))
draw_bg = ImageDraw.Draw(background)

# 创建前景图层 - 奶蛙图案
foreground = Image.new('RGBA', (216, 216), (0, 0, 0, 0))
draw = ImageDraw.Draw(foreground)

# 绘制奶蛙身体 - 椭圆形（黄色）
# 身体
draw.ellipse([48, 60, 168, 180], fill=(255, 230, 50, 255), outline=(200, 180, 0, 255), width=3)

# 左眼睛白色部分
draw.ellipse([60, 70, 100, 110], fill=(255, 255, 255, 255), outline=(0, 0, 0, 255), width=2)
# 右眼睛白色部分
draw.ellipse([116, 70, 156, 110], fill=(255, 255, 255, 255), outline=(0, 0, 0, 255), width=2)

# 左眼睛黑色瞳孔
draw.ellipse([72, 82, 92, 102], fill=(0, 0, 0, 255))
# 右眼睛黑色瞳孔
draw.ellipse([128, 82, 148, 102], fill=(0, 0, 0, 255))

# 左眼睛高光
draw.ellipse([76, 86, 84, 94], fill=(255, 255, 255, 255))
# 右眼睛高光
draw.ellipse([132, 86, 140, 94], fill=(255, 255, 255, 255))

# 嘴巴 - 微笑曲线
draw.arc([70, 120, 146, 160], start=0, end=180, fill=(200, 100, 50, 255), width=4)

# 腮红 - 左
draw.ellipse([50, 115, 75, 135], fill=(255, 150, 150, 180))
# 腮红 - 右
draw.ellipse([141, 115, 166, 135], fill=(255, 150, 150, 180))

# 左腿
draw.ellipse([40, 160, 80, 190], fill=(255, 230, 50, 255), outline=(200, 180, 0, 255), width=2)
# 右腿
draw.ellipse([136, 160, 176, 190], fill=(255, 230, 50, 255), outline=(200, 180, 0, 255), width=2)

# 保存图片
background.save('entry/src/main/resources/base/media/background.png')
foreground.save('entry/src/main/resources/base/media/foreground.png')

print("✅ 黄色奶蛙图标创建成功！")
print("📁 background.png - 黄色背景")
print("📁 foreground.png - 奶蛙图案")
