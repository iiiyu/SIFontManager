//
//  FontInfo.m
//  FontDemo
//
//  Created by ChenYu Xiao on 7/16/14.
//  Copyright (c) 2014 Sumi Interactive. All rights reserved.
//

#import "FontsDataModel.h"

NSString *const kFontManagerBundleName = @"SIFontManager";
NSString *const kFontsDataPlistName = @"FontsData.plist";
NSString *const kFontsKey = @"Fonts";
NSString *const kFontSizeKey = @"FontSize";
NSString *const kFontInfoKey = @"FontInfo";
NSString *const kFontNameKey = @"FontName";
NSString *const kBoldContentFontPostScriptNameKey = @"BoldContentFontPostScriptName";
NSString *const kContentFontPostScriptNameKey = @"ContentFontPostScriptName";
NSString *const kImageNameKey = @"ImageName";
NSString *const kSelectedKey = @"Selected";
NSString *const kDownloadKey = @"Download";
NSString *const kSystemFontKey = @"SystemFont";
NSString *const kFontTypeKey = @"FontType";

@interface FontsDataModel()

@property (nonatomic, strong) NSDictionary *originalData;
@property (nonatomic, strong) NSBundle *fontsDataBundle;

@end

@implementation FontsDataModel

@synthesize originalData = _originalData;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:[UIApplication sharedApplication]];
        [self setupBundel];
        [self setupPlist];
    }
    return self;
}

- (void)didReceiveMemoryWarning:(NSNotification *)notification
{
    _originalData = nil;
}

- (void)setupBundel
{
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:kFontManagerBundleName withExtension:@"bundle"];
    self.fontsDataBundle = [NSBundle bundleWithURL:bundleURL];
}


- (void)setupPlist
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *applicationSupportPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    BOOL isDirectory = YES;
    NSError *error;
    
    if (![fileManager fileExistsAtPath:applicationSupportPath isDirectory:&isDirectory]) {
        [fileManager createDirectoryAtPath:applicationSupportPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }
    
    NSString *fontsDataPlistFilePath = [applicationSupportPath stringByAppendingPathComponent:kFontsDataPlistName];
    if (![fileManager fileExistsAtPath:fontsDataPlistFilePath]) {

        [fileManager copyItemAtPath:[self.fontsDataBundle pathForResource:kFontsDataPlistName ofType:nil] toPath:fontsDataPlistFilePath error:&error];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }
}

#pragma mark - Get && Set methods

- (NSDictionary *)originalData
{
    if (_originalData) {
        return _originalData;
    }
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [path stringByAppendingPathComponent:kFontsDataPlistName];
    _originalData = [NSDictionary dictionaryWithContentsOfFile:file];
    return _originalData;
}

- (void)setOriginalData:(NSDictionary *)originalData
{
    if (![_originalData isEqualToDictionary:originalData]) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
        NSString *file = [path stringByAppendingPathComponent:kFontsDataPlistName];
        if (![originalData writeToFile:file atomically:YES]) {
            NSLog(@"write file is fail! File Path : %@", file);
        }
        _originalData = originalData;
    }
}

- (NSDictionary *)selectedFontInfo
{
    if (_selectedFontInfo) {
        return _selectedFontInfo;
    }
    
    NSArray *fonts = ((NSArray *)self.originalData[kFontsKey]);
    for (NSUInteger i = 0; i < fonts.count; i++) {
        NSDictionary *fontInfosDict = fonts[i];
        NSArray *fontInfos = ((NSArray *)fontInfosDict[kFontInfoKey]);
        
        for (NSUInteger j = 0; j < fontInfos.count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NSDictionary *dict = [self fontInfoWithIndexPath:indexPath];
            if ([dict[kSelectedKey] boolValue]) {
                _selectedFontInfo = dict;
                break;
            }
        }
    }
    return _selectedFontInfo;
}

#pragma mark - Public methods

- (NSUInteger)sectionCount
{
    return ((NSArray *)self.originalData[kFontsKey]).count;
}

- (NSUInteger)rowCountWithSection:(NSUInteger)section
{
    NSDictionary *fontInfosDict = ((NSArray *)self.originalData[kFontsKey])[section];
    return ((NSArray *)fontInfosDict[kFontInfoKey]).count;
}

- (NSDictionary *)fontInfoWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *fontInfosDict = ((NSArray *)self.originalData[kFontsKey])[indexPath.section];
    NSArray *fontInfos = ((NSArray *)fontInfosDict[kFontInfoKey]);
    return fontInfos[indexPath.row];
}

- (NSString *)contentFontPostScriptNameWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self fontInfoWithIndexPath:indexPath];
    return dict[kContentFontPostScriptNameKey];
}

- (NSString *)boldContentFontPostScriptNameWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self fontInfoWithIndexPath:indexPath];
    return dict[kBoldContentFontPostScriptNameKey];
}

- (NSString *)fontNameWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self fontInfoWithIndexPath:indexPath];
    return dict[kFontNameKey];
}

- (NSString *)fontInfoImageNameWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self fontInfoWithIndexPath:indexPath];
    return dict[kImageNameKey];
}

- (UIImage *)fontInfoImageWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self fontInfoWithIndexPath:indexPath];
    NSString *imageName = dict[kImageNameKey];
    NSString *imageFilePath = [self.fontsDataBundle pathForResource:imageName ofType:nil];
    UIImage *image;
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageFilePath]) {
        image = [UIImage imageWithContentsOfFile:imageFilePath];
    }
    return image;
}

- (BOOL)fontIsDownloadedWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self fontInfoWithIndexPath:indexPath];
    return [dict[kDownloadKey] boolValue] || [dict[kSystemFontKey] boolValue];
}


- (BOOL)fontIsSelectedWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self fontInfoWithIndexPath:indexPath];
    return [dict[kSelectedKey] boolValue];
}

- (BOOL)fontIsSystemFontWithWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self fontInfoWithIndexPath:indexPath];
    return [dict[kSystemFontKey] boolValue];
}


- (NSIndexPath *)indexPathWithContentFontPostScriptName:(NSString *)fontName
{
    NSArray *fonts = ((NSArray *)self.originalData[kFontsKey]);
    for (NSUInteger i = 0; i < fonts.count; i++) {
        NSDictionary *fontInfosDict = fonts[i];
        NSArray *fontInfos = ((NSArray *)fontInfosDict[kFontInfoKey]);
        
        for (NSUInteger j = 0; j < fontInfos.count; j++) {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
            if ([fontName isEqualToString:[self contentFontPostScriptNameWithIndexPath:tmpIndexPath]]) {
                return tmpIndexPath;
            }
        }
    }
    
    return nil;
}

- (NSArray *)downloadedFontsName
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *fonts = ((NSArray *)self.originalData[kFontsKey]);
    for (NSUInteger i = 0; i < fonts.count; i++) {
        NSDictionary *fontInfosDict = fonts[i];
        NSArray *fontInfos = ((NSArray *)fontInfosDict[kFontInfoKey]);
        
        for (NSUInteger j = 0; j < fontInfos.count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NSDictionary *dict = [self fontInfoWithIndexPath:indexPath];
            // 排除掉系统自带的字体
            if ([dict[kDownloadKey] boolValue] && ![dict[kSystemFontKey] boolValue]) {
                [result addObject:dict[kContentFontPostScriptNameKey]];
            }
        }
    }
    return result;
}

- (FontSize)fontSize
{
    return [self.originalData[kFontSizeKey] integerValue];
}

- (void)setFontSize:(FontSize)fontSize
{
    NSMutableDictionary *data = [self.originalData mutableCopy];
    [data setObject:@(fontSize) forKey:kFontSizeKey];
    self.originalData = data;
}

- (void)setSelectFontWithIndexPath:(NSIndexPath *)indexPath completion:(void(^)(NSIndexPath *oldIndexPath))completionBlock
{
    NSMutableDictionary *plistData = [[NSMutableDictionary alloc] init];
    NSIndexPath *oldIndexPath;
    // 1.
    [plistData setObject:self.originalData[kFontSizeKey] forKey:kFontSizeKey];
    
    // 2.
    NSArray *fonts = ((NSArray *)self.originalData[kFontsKey]);
    NSMutableArray *pFonts = [[NSMutableArray new] init];
    for (NSUInteger i = 0; i < fonts.count; i++) {
        NSDictionary *fontInfosDict = fonts[i];
        NSMutableDictionary *pFontInfosDict = [[NSMutableDictionary alloc] init];
        [pFontInfosDict setObject:fontInfosDict[kFontTypeKey] forKey:kFontTypeKey];
        
        NSArray *fontInfos = ((NSArray *)fontInfosDict[kFontInfoKey]);
        NSMutableArray *pFontInfos = [[NSMutableArray alloc] init];
        for (NSUInteger j = 0; j < fontInfos.count; j++) {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NSMutableDictionary *dict = [fontInfos[tmpIndexPath.row] mutableCopy];
            
            if ([dict[kSelectedKey] boolValue]) {
                oldIndexPath = tmpIndexPath;
            }
            
            if ([tmpIndexPath compare: indexPath] == NSOrderedSame) {
                [dict setObject:@YES forKey:kSelectedKey];
                self.selectedFontInfo = dict;
            } else {
                [dict setObject:@NO forKey:kSelectedKey];
            }
            
            [pFontInfos addObject:dict];
        }
        
        [pFontInfosDict setObject:pFontInfos forKey:kFontInfoKey];
        
        [pFonts addObject:pFontInfosDict];
    }
    
    [plistData setObject:pFonts forKey:kFontsKey];
    
    self.originalData = plistData;
    
    if (completionBlock) {
        completionBlock(oldIndexPath);
    }
}


- (void)setIsDownload:(BOOL)downloadFlag contentFontPostScriptName:(NSString *)fontName
{
    NSMutableDictionary *plistData = [[NSMutableDictionary alloc] init];
    // 1.
    [plistData setObject:self.originalData[kFontSizeKey] forKey:kFontSizeKey];
    
    // 2.
    NSArray *fonts = ((NSArray *)self.originalData[kFontsKey]);
    NSMutableArray *pFonts = [[NSMutableArray new] init];
    for (NSUInteger i = 0; i < fonts.count; i++) {
        NSDictionary *fontInfosDict = fonts[i];
        NSMutableDictionary *pFontInfosDict = [[NSMutableDictionary alloc] init];
        [pFontInfosDict setObject:fontInfosDict[kFontTypeKey] forKey:kFontTypeKey];
        
        NSArray *fontInfos = ((NSArray *)fontInfosDict[kFontInfoKey]);
        NSMutableArray *pFontInfos = [[NSMutableArray alloc] init];
        for (NSUInteger j = 0; j < fontInfos.count; j++) {
            
            
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NSMutableDictionary *dict = [fontInfos[tmpIndexPath.row] mutableCopy];
            
            // 回复第一个为默认选择
            if (i == 0 && j == 0) {
                if (!downloadFlag && [[self selectedFontInfo][kContentFontPostScriptNameKey] isEqualToString:fontName]) {
                    [dict setObject:@YES forKey:kSelectedKey];
                    self.selectedFontInfo = dict;
                }
            }
            
            if ([dict[kContentFontPostScriptNameKey] isEqualToString:fontName]) {
                if ([dict[kDownloadKey] boolValue] == downloadFlag) {
                    return;
                }
                [dict setObject:@(downloadFlag) forKey:kDownloadKey];
                
                if ([dict[kSelectedKey] boolValue]) {
                    [dict setObject:@NO forKey:kSelectedKey];
                }
                
            }
            
            [pFontInfos addObject:dict];
        }
        
        [pFontInfosDict setObject:pFontInfos forKey:kFontInfoKey];
        
        [pFonts addObject:pFontInfosDict];
    }
    
    [plistData setObject:pFonts forKey:kFontsKey];
    
    self.originalData = plistData;
    
}



@end
