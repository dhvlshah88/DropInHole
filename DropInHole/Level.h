//
//  Scores.h
//  SQL
// 
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Level : NSObject {

	//will have data to display on the screen, which will be loaded from Database
    NSInteger labelID;
	NSString *levelName;
	NSDecimalNumber *score;
}

@property (nonatomic, readonly) NSInteger labelID;
@property (nonatomic, copy) NSString *levelName;
@property (nonatomic, copy) NSDecimalNumber *score;


//Static methods.
//To load data independent to any instant
+ (void) getInitialDataToDisplay:(NSString *)dbPath;
+ (void) finalizeStatements;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;

@end
