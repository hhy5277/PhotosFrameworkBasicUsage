//
//  ZLNumberScrollView.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/19.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "ZLNumberScrollView.h"

@interface ZLNumberScrollView()
@property (nonatomic, strong) NSMutableArray *scrollViewArray;
@property (nonatomic, strong) NSArray *charactersArray;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation ZLNumberScrollView

// 新的数字不是从这里添加
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setDefaultAttributes];
    }
    return self;
}

// 新的数字不是从这里添加
-(void)setDefaultAttributes
{
    self.backgroundColor = [UIColor whiteColor];
    self.characterWidth = 8.0f;
    self.textFont = [UIFont systemFontOfSize:12];
    self.textColor = [UIColor blackColor];
    self.scrollViewArray = [NSMutableArray array];
    self.style = ZLScrollDirectionStyleUp;
    self.duration = 1.0f;
    [self addMaskLayer];
}
// 新的数字不是从这里添加
-(UIBezierPath *)creatBezierPath
{
    CGFloat height = [@"9" boundingRectWithSize:CGSizeMake(kScreenWidth, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kNumberFont} context:nil].size.height;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, height)];
    return bezierPath;
}
// 新的数字不是从这里添加
-(void)addMaskLayer
{
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.path = [self creatBezierPath].CGPath;
    self.layer.mask = self.maskLayer;
}
// 新的数字不是从这里添加
-(void)updateMaskLayout
{
    self.layer.mask = nil;
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.path = [self creatBezierPath].CGPath;
    self.layer.mask = self.maskLayer;
}

// 数字是从这里添加
-(void)setNumberText:(NSString *)numberText
{
    if (![_numberText isEqualToString:numberText]) {
        NSInteger oldLength = _numberText.length;
        NSInteger newLength = numberText.length;
        if(newLength > oldLength){
            NSInteger needLength = newLength - oldLength;
            for(int i = 0 ; i < needLength; i++){
                [self addNewASCharacterView];
            }
        } else if(newLength < oldLength){
            NSInteger needLength = oldLength - newLength;
            for(int i = 0 ; i < needLength; i++){
                [self deleteRedundantCharacterView];
            }
        }
        //Update the layout about the array
        [self updateLayout];
        
        __block CGFloat itemX = 0;
        [self.scrollViewArray enumerateObjectsUsingBlock:^(ZLCharacterView *characterView, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *character = [numberText substringWithRange:NSMakeRange(idx, 1)];
            // 数字是从这里添加
            [characterView setShowCharacter:character animated:YES];
            //            characterView.backgroundColor = [UIColor greenColor];
            
            CGFloat characterW = [character boundingRectWithSize:CGSizeMake(100, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kNumberFont} context:nil].size.width;
            CGRect characterFrame = characterView.frame;
            characterFrame.size.width = characterW;
            //            if ([character isEqualToString:@","]) {
            //                characterFrame.size.width = 10;
            ////                characterView.frame = characterFrame;
            //            }
            
            characterFrame.origin.x = itemX;
            characterView.frame = characterFrame;
            itemX += characterFrame.size.width;
        }];
        _numberText = numberText;
    }
}

// 新的数字不是从这里添加
-(void)updateLayout
{
    __block float originX = 0;
    float originY = 0;
    if (self.style == ZLScrollDirectionStyleDown) {
        originY = -((self.charactersArray.count - 1) * self.textFont.lineHeight);
    }else{
        originY = 0;
    }
    [self.scrollViewArray enumerateObjectsUsingBlock:^(ZLCharacterView *characterView, NSUInteger idx, BOOL * _Nonnull stop) {
        characterView.frame = CGRectMake(originX, originY, self.characterWidth, self.charactersArray.count * self.textFont.lineHeight);
        originX += self.characterWidth;
    }];
}

- (void)addNewASCharacterView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.characterWidth, self.charactersArray.count * self.textFont.lineHeight)];
    label.textColor = self.textColor;
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = self.textFont;
    ZLCharacterView *characterView = [[ZLCharacterView alloc]initWithFrame:CGRectMake(0, 0, self.characterWidth, self.charactersArray.count * self.textFont.lineHeight) WithTextLabel:label];
    
    characterView.showCharacter = @"0";
    characterView.showCharacterIndex = self.charactersArray.count - 1;
    characterView.style = self.style;
    characterView.duration = self.duration;
    characterView.characterArray = self.charactersArray;
    [self addSubview:characterView];
    
    [self.scrollViewArray addObject:characterView];
}

// 删除多余的文本,新的数字不是从这里添加
-(void)deleteRedundantCharacterView
{
    if (self.scrollViewArray.count > 0) {
        ZLCharacterView *characterView = (ZLCharacterView *)self.scrollViewArray[0];
        [characterView removeFromSuperview];
        [self.scrollViewArray removeObject:characterView];
    }
}

// 新的数字不是从这里添加
-(void)setCharacterWidth:(float)characterWidth
{
    if (characterWidth != _characterWidth) {
        _characterWidth = characterWidth;
        //update mask
        [self updateMaskLayout];
    }
}
// 新的数字不是从这里添加
-(void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
}
// 新的数字不是从这里添加
-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
}
// 新的数字不是从这里添加
-(void)setDuration:(float)duration
{
    _duration = duration;
}
// 新的数字不是从这里添加
-(void)setStyle:(ZLScrollDirectionStyle)style
{
    if (_style != style) {
        _style = style;
        if (style == ZLScrollDirectionStyleDown) {
            self.charactersArray = @[@"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", @"1", @"0", @","];
        }else{
            self.charactersArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @","];
        }
        
    }
}

- (void)drawRect:(CGRect)rect {
    
}


@end
