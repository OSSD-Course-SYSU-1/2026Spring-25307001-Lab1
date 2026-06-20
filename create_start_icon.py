from PIL import Image

# 使用前景图层作为启动图标
foreground = Image.open('entry/src/main/resources/base/media/foreground.png')
background = Image.open('entry/src/main/resources/base/media/background.png')

# 合并背景和前景创建启动图标
startIcon = Image.alpha_composite(background, foreground)
startIcon.save('entry/src/main/resources/base/media/startIcon.png')

print("✅ 启动图标更新成功！")
