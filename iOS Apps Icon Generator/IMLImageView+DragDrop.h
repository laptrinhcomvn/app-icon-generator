//
//  IMLImageView+DragDrop.h
//  iOS Apps Icon Generator
//
//  Created by Le Anh Tung on 5/15/15.
//  Copyright (c) 2015 © IML. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol IMLImageView_DragDropDelegate <NSObject>

- (void)dropComplete:(NSString *)filePath;

@end

@interface IMLImageView_DragDrop : NSImageView <NSDraggingSource, NSDraggingDestination, NSPasteboardItemDataProvider> {
    BOOL highlight;
}

@property (assign) BOOL allowDrag;
@property (assign) BOOL allowDrop;
@property (assign) id<IMLImageView_DragDropDelegate> delegate;

@end


