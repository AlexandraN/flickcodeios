//
//  FlickCode.h
//  Custom Keyboard Learn
//
//  Created by Alexandra Niculai on 02/11/12.
//  Copyright (c) 2012 fandaliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickCode : NSObject

@property(nonatomic, strong) NSArray *allFlicks;

-(void)loadFlicks;
-(NSString *)getFunction:(NSString *)flickSequence;
-(NSString *)getCharacter:(NSString *)flickSequence;
-(NSString *)getStringToBeSpoken:(NSString *)flickSequence;
-(NSString *)getCorrespondingStringForFlickSequenceOrFullGesture:(NSString *)flickSequenceOrFullGesture;
-(NSArray *)getPossibleNextFunctionsAndCharactersAfterFlickSequence: (NSString *)flickSequence;

@end
