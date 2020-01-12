#!/usr/bin/env python
# -*- coding: utf-8 -*-

from gimpfu import *
import os

def plugin_main(image, layer, dir_path):
    if (not type(dir_path) == type("") or not len(dir_path)):
        gimp.message("フォルダを選択して下さい")
        return
    #app_iconsフォルダ作成
    app_icons_dir_path = dir_path+"/app_icons"
    os.mkdir(app_icons_dir_path)
    #ファイル保存
    save_files(image, layer, app_icons_dir_path)

def save_file(image, layer, dir_path, file_name): 
    file_path = dir_path+"/"+file_name
    #画像を保存
    pdb.file_png_save(image, layer, file_path, file_path, 1.0, 0, 0, 0, 0, 0, 0)

def save_files(image, layer, dir_path): 
    pdb.gimp_image_scale(image, 1024, 1024)
    file_name = "icon_1024.png"
    save_file(image, layer, dir_path, file_name)
    pdb.gimp_image_scale(image, 180, 180)
    file_name = "icon_60@3x.png"
    save_file(image, layer, dir_path, file_name)
    pdb.gimp_image_scale(image, 167, 167)
    file_name = "icon_83_5@2x.png"
    save_file(image, layer, dir_path, file_name)
    pdb.gimp_image_scale(image, 152, 152)
    file_name = "icon_76@2x.png"
    save_file(image, layer, dir_path, file_name)
    pdb.gimp_image_scale(image, 120, 120)
    file_name = "icon_60@2x.png"
    save_file(image, layer, dir_path, file_name)
    file_name = "icon_40@3x.png"
    save_file(image, layer, dir_path, file_name)
    pdb.gimp_image_scale(image, 87, 87)
    file_name = "icon_29@3x.png"
    save_file(image, layer, dir_path, file_name)
    pdb.gimp_image_scale(image, 80, 80)
    file_name = "icon_40@2x.png"
    save_file(image, layer, dir_path, file_name)
    pdb.gimp_image_scale(image, 76, 76)
    file_name = "icon_76.png"
    save_file(image, layer, dir_path, file_name)
    pdb.gimp_image_scale(image, 60, 60)
    file_name = "icon_20@3x.png"
    save_file(image, layer, dir_path, file_name)
    pdb.gimp_image_scale(image, 58, 58)
    file_name = "icon_29@2x.png"
    save_file(image, layer, dir_path, file_name)
    pdb.gimp_image_scale(image, 40, 40)
    file_name = "icon_40.png"
    save_file(image, layer, dir_path, file_name)
    file_name = "icon_20@2x.png"
    save_file(image, layer, dir_path, file_name)
    pdb.gimp_image_scale(image, 29, 29)
    file_name = "icon_29.png"
    save_file(image, layer, dir_path, file_name)
    pdb.gimp_image_scale(image, 20, 20)
    file_name = "icon_20.png"
    save_file(image, layer, dir_path, file_name)

register(
    "python_fu_resize_icons_ios",
    "Resize for iOS app icons",
    "Resize for iOS app icons",
    "am10",
    "am10",
    "2020/1/12",
    "<Image>/Filters/Languages/Python-Fu/iOS-resizeIcons", 
    "RGB*, GRAY*", 
    [
    (PF_DIRNAME, "directory_path", "Save directoryPath", ""),
    ],
    [], 
    plugin_main) 

main()
