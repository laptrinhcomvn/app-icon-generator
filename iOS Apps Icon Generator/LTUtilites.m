//
//  LTUtilites.m
//  iOS Apps Icon Generator
//
//  Created by Le Anh Tung on 5/18/15.
//  Copyright (c) 2015 © IML. All rights reserved.
//

#import "LTUtilites.h"
#import <Quartz/Quartz.h>
#import <AppKit/AppKit.h>

@implementation LTUtilites

+ (NSImage*)resizeImageWithPath:(NSString *)path toSize:(CGSize)size {
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:path];
    NSRect targetFrame = NSMakeRect(0, 0, size.width, size.height);
    
    NSImage* targetImage = nil;
    NSImageRep *sourceImageRep = [img bestRepresentationForRect:targetFrame context:nil hints:nil];
    
    targetImage = [[NSImage alloc] initWithSize:size];
    
    [targetImage lockFocus];
    [sourceImageRep drawInRect: targetFrame];
    [targetImage unlockFocus];
    
    return targetImage;
}

+ (BOOL)writeImage:(NSImage *)image toPath:(NSString *)path {
    CGImageRef cgRef = [image CGImageForProposedRect:NULL
                                             context:nil
                                               hints:nil];
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    [newRep setSize:[image size]];   // if you want the same resolution
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
    return [pngData writeToFile:path atomically:YES];
    
    //return [[[[image representations] objectAtIndex:0] representationUsingType:NSPNGFileType properties:nil] writeToFile:path atomically:YES];
}



@end
