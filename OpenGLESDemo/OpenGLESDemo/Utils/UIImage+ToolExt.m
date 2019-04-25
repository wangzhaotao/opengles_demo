//
//  UIImage+ToolExt.m
//  OpenGLESDemo
//
//  Created by tyler on 4/25/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "UIImage+ToolExt.h"

@implementation UIImage (ToolExt)

-(void)saveImageToPhotoLibrary {
    
    // UIImageWriteToSavedPhotosAlbum 这个方法,默认保存到系统相机胶卷,但是@selector后面的方法 必须是这种格式:
    //- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    //保存图片到系统相册
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


#pragma mark private methods
/**
 *  写入图片后执行的操作
 *
 *  @param image       写入的图片
 *  @param error       错误信息
 *  @param contextInfo UIImageWriteToSavedPhotosAlbum第三个参数
 */
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        NSLog(@"保存图片到相册失败");
    }
    else  {
        NSLog(@"保存图片到相册成功");
    }
}

@end
