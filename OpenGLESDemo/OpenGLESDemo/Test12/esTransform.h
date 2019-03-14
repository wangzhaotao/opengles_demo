//
//  esTransform.h
//  OpenGLESDemo
//
//  Created by tyler on 3/14/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

typedef struct
{
    GLfloat   m[4][4];
} ESMatrix;

void esScale( ESMatrix *result, GLfloat sx, GLfloat sy, GLfloat sz );
void esTranslate( ESMatrix *result, GLfloat tx, GLfloat ty, GLfloat tz );
void esRotate ( ESMatrix *result, GLfloat angle, GLfloat x, GLfloat y, GLfloat z );
void esFrustum ( ESMatrix *result, float left, float right, float bottom, float top, float nearZ, float farZ );
void esPerspective ( ESMatrix *result, float fovy, float aspect, float nearZ, float farZ );
void esOrtho ( ESMatrix *result, float left, float right, float bottom, float top, float nearZ, float farZ );
void esMatrixMultiply ( ESMatrix *result, ESMatrix *srcA, ESMatrix *srcB );
void esMatrixLoadIdentity ( ESMatrix *result );
void esMatrixLookAt ( ESMatrix *result,
                     float posX,    float posY,    float posZ,
                     float lookAtX, float lookAtY, float lookAtZ,
                     float upX,     float upY,     float upZ );

@interface esTransform : NSObject

@end

