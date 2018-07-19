//
//  CustomStatusBarView.m
//  MacSimpleDemo
//
//  Created by liyu on 2018/7/19.
//  Copyright © 2018年 liyu. All rights reserved.
//

#import "CustomStatusBarView.h"

@implementation CustomStatusBarView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

+ (NSView *)loadWithNibNamed:(NSString *)nibName owner:(id)owner loadClass:(NSString *)loadClass {
    NSNib *nib = [[NSNib alloc] initWithNibNamed:nibName bundle:nil];
    NSArray *topLevelObjects;
    CustomStatusBarView *statusBarView = nil;
    if ([nib instantiateWithOwner:owner topLevelObjects:&topLevelObjects]) {
        for (id topLevelObject in topLevelObjects) {
            if ([topLevelObject isKindOfClass:[loadClass class]]) {
                statusBarView = topLevelObject;
                break;
            }
        }
    }
    return statusBarView;
}

@end
