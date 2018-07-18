//
//  ThirdWindowController.m
//  WindowTest
//
//  Created by liyu on 2018/7/16.
//  Copyright © 2018年 liyu. All rights reserved.
//

#import "ThirdWindowController.h"
#import "CollectionViewItem.h"

@interface ThirdWindowController ()

@end

@implementation ThirdWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setTitle:@"ThirdWindowController"];
    NSImage *image = [NSImage imageNamed:@"Mac"];
    [[self.window standardWindowButton:NSWindowDocumentIconButton] setImage:image];
    [self.window setOpaque:NO];
    self.window.backgroundColor =[NSColor cyanColor];
    self.window.contentView.layer.backgroundColor = [NSColor yellowColor].CGColor;
    self.window.contentView.wantsLayer = YES;
    // 点击背景可以移动
    [self.window setMovableByWindowBackground:YES];
    [self addCollectView];
}

- (void)addCollectView {
    NSCollectionView *collectionView = [[NSCollectionView alloc]initWithFrame:[self.window.contentView bounds]];
    [[self.window contentView]addSubview:collectionView];
    CollectionViewItem *itemPrototype = [[CollectionViewItem alloc]initWithNibName:@"CollectionViewItem" bundle:nil];
    collectionView.itemPrototype = itemPrototype;
    NSArray *array0 = @[NSImageNameMobileMe,NSImageNameMultipleDocuments,NSImageNameUserAccounts,NSImageNamePreferencesGeneral,NSImageNameAdvanced,NSImageNameInfo,NSImageNameFontPanel,NSImageNameColorPanel,NSImageNameUser,NSImageNameUserGroup];
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];
    for (NSString *imgName in array0) {
        NSImage *img = [NSImage imageNamed:imgName];
        NSDictionary *item5 = @{@"title":imgName, @"image":img};
        [itemArray addObject:item5];
    }
    collectionView.content = itemArray;
}

@end
