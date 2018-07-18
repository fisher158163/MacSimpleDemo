//
//  CollectionViewItem.m
//  WindowTest
//
//  Created by liyu on 2018/7/16.
//  Copyright © 2018年 liyu. All rights reserved.
//

#import "CollectionViewItem.h"

@interface CollectionViewItem ()
@property (weak) IBOutlet NSImageView *collImageView;
@property (weak) IBOutlet NSTextField *titleField;
@end

@implementation CollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.representedObject){
        return;
    }
    self.collImageView.image = [self.representedObject objectForKey:@"image"];
    self.titleField.stringValue = [self.representedObject objectForKey:@"title"];
    self.titleField.maximumNumberOfLines = 0;
    self.collImageView.imageScaling = NSImageScaleNone;
}

@end
