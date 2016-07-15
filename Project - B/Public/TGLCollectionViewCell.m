//
//  TGLCollectionViewCell.m
//  TGLStackedViewExample
//
//  Created by Tim Gleue on 07.04.14.
//  Copyright (c) 2014 Tim Gleue ( http://gleue-interactive.com )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <QuartzCore/QuartzCore.h>

#import "TGLCollectionViewCell.h"

@interface TGLCollectionViewCell ()

//@property (weak, nonatomic) IBOutlet UIView *roundedView;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TGLCollectionViewCell

//- (void)awakeFromNib {
//    
//    [super awakeFromNib];
//
//    self.opaque = NO;
//    self.backgroundColor = [UIColor whiteColor];
//    
//    self.roundedView.backgroundColor = self.color;
//
//    self.roundedView.layer.cornerRadius = 10.0;
//    self.roundedView.layer.borderWidth = 1.0;
//    self.roundedView.layer.borderColor = [UIColor blackColor].CGColor;
//    
//    self.nameLabel.text = self.title;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.roundedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.contentView addSubview:_roundedView];
        
        self.buildTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 100, 30, 200, 20)];
        self.buildTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_buildTimeLabel];
        
        
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
//        self.roundedView.backgroundColor = self.color;
        
        self.roundedView.layer.cornerRadius = 10.0;
        self.roundedView.layer.borderWidth = 1.0;
        self.roundedView.layer.borderColor = [UIColor blackColor].CGColor;
        
        self.buildTimeLabel.text = self.title;
    }
    return self;
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title {

    _title = [title copy];
    
    self.buildTimeLabel.text = self.title;
}

- (void)setColor:(UIColor *)color {

    _color = [color copy];
    
    self.roundedView.backgroundColor = self.color;
}

#pragma mark - Methods

- (void)setSelected:(BOOL)selected {

    [super setSelected:selected];
    
    self.roundedView.layer.borderColor = self.selected ? [UIColor whiteColor].CGColor : [UIColor blackColor].CGColor;
}

@end
