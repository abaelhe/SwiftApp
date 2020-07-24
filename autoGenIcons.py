#!/usr/bin/env python
#coding=utf-8

import os,sys,threading
from PIL import Image
import subprocess
import json


InputImage = "./app.jpg"
OutputDir  = "./AppIcons/"
UsageInfo  = "<autoGenIcons.py> <inputImageFile> [outputDir]"
Metrics = """
{
  "images" : [
    {
      "size" : "40x40",
      "idiom" : "iphonenotify",
      "filename" : "iphoneNotification-40@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphonennotify",
      "filename" : "iphoneNotification-60@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "58x58",
      "idiom" : "iphonesettings",
      "filename" : "iphoneSettings-58@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "87x87",
      "idiom" : "iphonesettings",
      "filename" : "iphoneSettings-87@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "80x80",
      "idiom" : "iphonespotlight",
      "filename" : "iphoneSpotlight-80@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "120x120",
      "idiom" : "iphonespotlight",
      "filename" : "iphoneSpotlight-120@3x.jpg",
      "scale" : "3x"
    },
    {
      "size" : "120x120",
      "idiom" : "iphonePpp",
      "filename" : "iphoneApp-120@2x.jpg",
      "scale" : "2x"
    },
    {
      "size" : "180x180",
      "idiom" : "iphoneapp",
      "filename" : "iphoneapp-180@3x.jpg",
      "scale" : "3x"
    },
    {
      "size" : "20x20",
      "idiom" : "ipadnotify",
      "filename" : "ipadNotification-20@1x.jpg",
      "scale" : "1x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipadnotify",
      "filename" : "ipadNotification-40@2x.jpg",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipadsettings",
      "filename" : "ipadSettings-29@1x.jpg",
      "scale" : "1x"
    },
    {
      "size" : "58x58",
      "idiom" : "ipadsettings",
      "filename" : "ipadSettings-58@2x.jpg",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipadspotlight",
      "filename" : "ipadSpotlight-40@1x.png",
      "scale" : "1x"
    },
    {
      "size" : "80x80",
      "idiom" : "ipadspotlight",
      "filename" : "ipadSpotlight-80@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipadapp",
      "filename" : "ipadApp-76@1x.jpg",
      "scale" : "1x"
    },
    {
      "size" : "152x152",
      "idiom" : "ipadapp",
      "filename" : "ipadApp-152@2x.jpg",
      "scale" : "2x"
    },
    {
      "size" : "167x167",
      "idiom" : "ipadproapp",
      "filename" : "ipadProApp-167@2x.jpg",
      "scale" : "2x"
    },
    {
      "size" : "1024x1024",
      "idiom" : "ios-marketing",
      "filename" : "AppStore-1024.jpg",
      "scale" : "1x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
"""


def normalizationDir(filePath):
    normPath = os.path.abspath(os.path.expanduser(os.path.expandvars(filePath)))
    return normPath


    #json 数据里面有效数据的类
class iconImage(object):
    """
    "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "Icon-Small@3x.png",
      "scale" : "3x"
    """
    def __init__(self,size,idiom,filename,scale):
        self._size = size
        self.idiom = idiom
        self.filename = filename
        self.scale = scale

    def __str__(self):
        print("%s,%s,%s,%s"%(self._size,self.idiom,self.filename,self.scale))

    @property
    def width(self):
        return float(self._size.split('x')[0])

    @property
    def height(self):
        return float(self._size.split('x')[1])

    @property
    def size(self):
        return tuple([self.width, self.height])

class ImgManager(object):
    thread_lock = threading.Lock()
    @classmethod
    def shared(cls, inputImage, outputDir=OutputDir):
        with ImgManager.thread_lock:
            if not hasattr(ImgManager,"instance"):
                ImgManager.instance = ImgManager(inputImage, outputDir)
        return ImgManager.instance

    def __init__(self, inputImage = InputImage, outputDir = OutputDir):
        self.inputImage= normalizationDir(inputImage)
        self.outputDir= normalizationDir(outputDir)

    # load metrics.json: all AppIcon for Images.xcassets included.
    def genIcons(self):
        metrics = json.loads(Metrics)
        arrs = metrics['images']
        for a in arrs:
            size=a["size"]
            idiom=a["idiom"]
            filename=os.path.basename(a["filename"])
            scale=a["scale"]

            icon =iconImage(size,idiom,filename,scale)
            self.createImg(icon, self.outputDir)

    def createImg(self,model, outputDir):
        currentPath = "%s/%s"%(outputDir,model.filename)
        width, height = model.size
        im = Image.open(self.inputImage,'r')
        im.thumbnail(model.size)

        if not os.path.exists(self.outputDir):
            os.makedirs(self.outputDir, exist_ok=True)

        if model.filename.endswith('.png'):
            im.save(currentPath)
        else:
            self.addTransparency(im)
            currentPath = currentPath.rsplit(".",1)[0]
            ext = "jpeg"
            im.save("%s.%s" % (currentPath,ext), ext)
            # r, g, b, alpha = im.split()

    def addTransparency(self, img, factor=0.0):
        img = img.convert('RGBA')
        img_blender = Image.new('RGBA', img.size, (0, 0, 256, 256))
        img = Image.blend(img_blender, img, factor)
        return img

    def runshellCMD(self,cmd):
        progress = subprocess.Popen(cmd,shell=True)
        progress.wait()
        result = progress.returncode
        if result !=0:
            print("Error: %s"%(cmd,))
        else:
            print("Done: %s"%(cmd,))


if __name__ == '__main__':
    outputDir = OutputDir
    args = sys.argv[1:]
    if len(args) == 0:
            print(UsageInfo)
            sys.exit(-1)
    inputImage = args[0]

    if len(args) > 1:
        outputDir = args[1]
        if not os.path.exists(outputDir) or not os.path.isdir(outputDir):
            print(UsageInfo)
            sys.exit(-1)

    ImgManager.shared(inputImage, outputDir).genIcons()


