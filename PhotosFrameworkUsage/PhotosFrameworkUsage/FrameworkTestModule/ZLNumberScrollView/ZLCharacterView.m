//
//  ZLCharacterView.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/19.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "ZLCharacterView.h"

@interface ZLCharacterView ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation ZLCharacterView

-(instancetype)initWithFrame:(CGRect)frame WithTextLabel:(UILabel *)label
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel = label;
        [self addSubview:label];
    }
    return self;
}

// 新的数字不是从这里添加
-(void)setCharacterArray:(NSArray *)characterArray
{
    _characterArray = characterArray;
    NSMutableString *string = [NSMutableString string];
    for(int i = 0; i < characterArray.count; i++){
        
        [string appendString: characterArray[i]];
        if(i != (characterArray.count - 1)){
            [string appendString: @"\n"];
        }
    }
    
    self.textLabel.text = string;
}

-(CGFloat)getPositionYWithIndex:(NSInteger)index
{
    return -index * (self.textLabel.frame.size.height / self.characterArray.count);
}

// 新的数字不是从这里添加
-(void)animationToPositionY:(CGFloat)positionY withCallback:(void(^)(void))callback {
    CGRect newFrame = self.frame;
    newFrame.origin.y = positionY;
    [UIView animateWithDuration:self.duration animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        callback();
    }];
}

// 数字是从这里添加
-(void)setShowCharacter:(NSString *)showCharacter animated:(BOOL)animated
{
    if (self.style == ZLScrollDirectionStyleUp) {
        NSInteger showCharacterIndex = showCharacter.integerValue;
        if (showCharacterIndex < self.showCharacterIndex) {
            [self animationToPositionY:[self getPositionYWithIndex:showCharacterIndex] withCallback:^{
                self.showCharacterIndex = showCharacterIndex;
                self.showCharacter = showCharacter;
            }];
        } else if (showCharacterIndex >= self.showCharacterIndex) {
            for (NSInteger i = self.characterArray.count / 2; i < self.characterArray.count; i++) {
                if ([self.characterArray[i] isEqualToString:showCharacter]) {
                    showCharacterIndex = i;
                    break;
                }
            }
            [self animationToPositionY:[self getPositionYWithIndex:showCharacterIndex] withCallback:^{
                self.showCharacterIndex = showCharacterIndex;
                self.showCharacter = showCharacter;
            }];
        }
    } else {
        // 95,487
        NSInteger showCharacterIndex = self.characterArray.count - 1 - showCharacter.integerValue;
        //        if (showCharacterIndex < self.showCharacterIndex) {
        //            [self animationToPositionY:[self getPositionYWithIndex:showCharacterIndex] withCallback:^{
        //                self.showCharacterIndex = showCharacterIndex;
        //                self.showCharacter = showCharacter;
        //            }];
        //        }else if (showCharacterIndex > self.showCharacterIndex) {
        for (NSInteger i = 0; i < self.characterArray.count; i++) {
            if ([self.characterArray[i] isEqualToString:showCharacter]) {
                showCharacterIndex = i;
                break;
            }
        }
        [self animationToPositionY:[self getPositionYWithIndex:showCharacterIndex] withCallback:^{
            self.showCharacterIndex =  [self.characterArray indexOfObject: showCharacter];
            self.showCharacter = showCharacter;
        }];
        //        }
    }
}


- (void)drawRect:(CGRect)rect {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect textFrame = self.textLabel.frame;
    textFrame.size.width = self.frame.size.width;
    self.textLabel.frame = textFrame;
}

@end
