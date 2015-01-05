//
//  FontInfo.h
//  FontDemo
//
//  Created by ChenYu Xiao on 7/16/14.
//  Copyright (c) 2014 Sumi Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kBoldContentFontPostScriptNameKey;
extern NSString *const kContentFontPostScriptNameKey;
extern NSString *const kFontSizeKey;

typedef NS_ENUM(NSUInteger, FontSize) {
    FontSizeExtraSmall = 0,
    FontSizeSmall,
    FontSizeNormal,
    FontSizeLarge,
    FontSizeExtraLarge,
};

@interface FontsDataModel : NSObject

@property (nonatomic, strong) NSDictionary *selectedFontInfo;

- (NSUInteger)sectionCount;

- (NSUInteger)rowCountWithSection:(NSUInteger)section;

// 通过indexPath 返回值

- (NSDictionary *)fontInfoWithIndexPath:(NSIndexPath *)indexPath;

- (NSString *)fontNameWithIndexPath:(NSIndexPath *)indexPath;

//- (NSString *)fontInfoImageNameWithIndexPath:(NSIndexPath *)indexPath;
- (UIImage *)fontInfoImageWithIndexPath:(NSIndexPath *)indexPath;

- (NSString *)contentFontPostScriptNameWithIndexPath:(NSIndexPath *)indexPath;

- (NSString *)boldContentFontPostScriptNameWithIndexPath:(NSIndexPath *)indexPath;

- (BOOL)fontIsDownloadedWithIndexPath:(NSIndexPath *)indexPath;

- (BOOL)fontIsSelectedWithIndexPath:(NSIndexPath *)indexPath;

- (BOOL)fontIsSystemFontWithWithIndexPath:(NSIndexPath *)indexPath;

// 通过名字 返回 indexPath

- (NSIndexPath *)indexPathWithContentFontPostScriptName:(NSString *)fontName;

- (NSArray *)downloadedFontsName;

- (FontSize)fontSize;
- (void)setFontSize:(FontSize)fontSize;

- (void)setSelectFontWithIndexPath:(NSIndexPath *)indexPath completion:(void(^)(NSIndexPath *oldIndexPath))completionBlock;

- (void)setIsDownload:(BOOL)downloadFlag contentFontPostScriptName:(NSString *)fontName;

@end
