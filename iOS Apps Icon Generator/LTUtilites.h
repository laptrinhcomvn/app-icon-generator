//
//  LTUtilites.h
//  iOS Apps Icon Generator
//
//  Created by Le Anh Tung on 5/18/15.
//  Copyright (c) 2015 © IML. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTUtilites : NSObject
+ (NSImage*)resizeImageWithPath:(NSString *)path toSize:(CGSize)size;
+ (BOOL)writeImage:(NSImage *)image toPath:(NSString *)path;
@end
