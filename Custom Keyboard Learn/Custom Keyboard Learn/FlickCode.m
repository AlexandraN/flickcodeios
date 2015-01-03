//
//  FlickCode.m
//  Custom Keyboard Learn
//
//  Created by Alexandra Niculai on 02/11/12.
//
//

#import "FlickCode.h"
#import "SBJson.h"

@interface FlickCode()

@property(nonatomic, strong) NSMutableDictionary *flickDictionary;
@property(nonatomic, strong) NSMutableDictionary *functionsDictionary;
@property(nonatomic, strong) NSMutableDictionary *speachDictionary;

@end

@implementation FlickCode
@synthesize flickDictionary, functionsDictionary, speachDictionary, allFlicks;


- (id)init
{
    self = [super init];
    if (self) {
        [self loadFlicks];
        allFlicks = [NSArray arrayWithObjects:@"^", @">" , @"v", @"<", @".", @":", nil];
    }
    return self;
}

-(void)loadFlicks {

    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *flickCodeFilePath = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"json"];
    NSString *flickCodeString = [NSString stringWithContentsOfFile:flickCodeFilePath encoding:NSUTF8StringEncoding error:nil];

    if (flickCodeString) {
        NSDictionary *allFile = [parser objectWithString:flickCodeString];

        NSArray *code = [allFile valueForKey:@"code"];

        flickDictionary = [NSMutableDictionary dictionary];
        functionsDictionary = [NSMutableDictionary dictionary];
        speachDictionary = [NSMutableDictionary dictionary];

        for (NSArray *flickCode in code) {
            int flickCodeCount = [flickCode count];

            [self loadSpeachDictionaryFrom:flickCode withFlickCodeCount:flickCodeCount];

            if (flickCodeCount >= 4 && [[flickCode objectAtIndex:3] isEqual:@"function"]) {
                [functionsDictionary setObject:[flickCode objectAtIndex:1] forKey:[flickCode objectAtIndex:0]];
            } else {
                [flickDictionary setObject:[flickCode objectAtIndex:1] forKey:[flickCode objectAtIndex:0]];
            }
        }
    }

}

-(void)loadSpeachDictionaryFrom:(NSArray *) flickCode withFlickCodeCount: (int) flickCodeCount{

    if (flickCodeCount >= 3) {
        NSDictionary *speach = [flickCode objectAtIndex:2];
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];

        NSString* stringToBeSpoken = [speach valueForKey:language];

        if (!stringToBeSpoken) {
            stringToBeSpoken = [speach valueForKey:@"en"];
        }

        [speachDictionary setObject:stringToBeSpoken forKey:[flickCode objectAtIndex:0]];
    }
}

-(NSString *)getFunction:(NSString *)flickSequence {

    return [functionsDictionary valueForKey:flickSequence];
}

-(NSString *)getCharacter:(NSString *)flickSequence {

    return [flickDictionary valueForKey:flickSequence];
}

-(NSString *)getStringToBeSpoken:(NSString *)flickSequence {
    return [speachDictionary valueForKey:flickSequence];
}

/**
 Gets string from the flick code (json file). This string corresponds to a partial gesture (one or two flicks)
 or to a full gesture (three flicks).
 */
- (NSString *)getCorrespondingStringForFlickSequenceOrFullGesture:(NSString *)flickSequenceOrFullGesture {

    NSString *toBeSpoken = [self getStringToBeSpoken:flickSequenceOrFullGesture];
    if (!toBeSpoken || [toBeSpoken length] == 0) {
        toBeSpoken = [self getCharacter:flickSequenceOrFullGesture];
    }
    return toBeSpoken;
}

-(NSArray *)getPossibleNextFunctionsAndCharactersAfterFlickSequence: (NSString *)flickSequence {

    NSMutableArray *nextStuff = [NSMutableArray array];
    for (NSString *flick in allFlicks) {
        NSString *nextSequence = [flickSequence stringByAppendingFormat:@"%@", flick];
        NSString *stringToBeSpoken = [self getCorrespondingStringForFlickSequenceOrFullGesture:nextSequence];
        if (stringToBeSpoken) {
            [nextStuff addObject:stringToBeSpoken];
        }
    }


    return nextStuff;
}

@end
