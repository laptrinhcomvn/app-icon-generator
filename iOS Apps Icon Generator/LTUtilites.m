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

    // Convert the target size to account for normal or retina screen
    // http://stackoverflow.com/a/15885854/505093
    CGFloat screenScale = [[NSScreen mainScreen] backingScaleFactor];
    float targetScaledWidth = size.width / screenScale;
    float targetScaledHeight = size.height / screenScale;

    NSRect targetFrame = NSMakeRect(0, 0, targetScaledWidth, targetScaledHeight);
    
    NSImage* targetImage = nil;
    NSImageRep *sourceImageRep = [img bestRepresentationForRect:targetFrame context:nil hints:nil];
    
    targetImage = [[NSImage alloc] initWithSize:NSMakeSize(targetScaledWidth, targetScaledHeight)];
    
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
    [newRep setSize:[image size]]; // if you want the same resolution
    
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:imageProps];
    return [pngData writeToFile:path atomically:YES];
    
    //return [[[[image representations] objectAtIndex:0] representationUsingType:NSPNGFileType properties:nil] writeToFile:path atomically:YES];
}



@end
