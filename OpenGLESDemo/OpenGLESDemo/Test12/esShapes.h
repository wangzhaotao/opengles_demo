//
//  esShapes.h
//  OpenGLESDemo
//
//  Created by tyler on 3/14/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

int esGenCube ( float scale, GLfloat **vertices, GLfloat **normals,
                          GLfloat **texCoords, GLuint **indices );

@interface esShapes : NSObject

@end

