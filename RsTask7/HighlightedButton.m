//
//  HighlightedButton.m
//  RsTask7
//
//  Created by Dzmitry Navitski on 03.07.2021.
//

#import <Foundation/Foundation.h>
#import "HighlightedButton.h"

@implementation HighlightedButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
        
    if (highlighted) {
        self.backgroundColor = [[UIColor colorNamed:@"LittleBoyBlue"] colorWithAlphaComponent:0.2];
    } else {
        self.backgroundColor = UIColor.whiteColor;
    }
}

@end
