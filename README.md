# MXCoding

iOS 中对象序列化，需要遵行NSCoding协议，然后对对象的每个属性进行归档和接档赋值，响应的操作比较繁琐。本文主要介绍 利用 runtime遍历属性 大大简化代码量

具体实现代码如下:
1.先建立NSobject的分类, 定义可能用到的相关类型
```
static NSString *intType     = @"i"; // int_32t(枚举int型)
static NSString *longTpye    = @"l"; //long类型
static NSString *longlongType= @"q"; // longlong类型
static NSString *BoolType    = @"B"; //bool类型
static NSString *floatType   = @"f"; // float
static NSString *doubleType  = @"d"; // double
static NSString *boolType    = @"c";
static NSString *stringType  = @"NSString"; // NSString 类型
static NSString *numberType  = @"NSNumber"; // NSNumber 类型
static NSString *arrayType   = @"arrayType";//array类型
static NSString *imageType   = @"UIImage"; // UIImage 类型
```

然后在归档方法中便利自身的属性名称，并且取出自身属性对应的值，进行存储到本地。此时遍历类属性本身，用到了Ivar指针（定义对象的实例变量，包括类型和名字），具体代码如下 
```
//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
unsigned int count; // 属性个数
Ivar *varArray = class_copyIvarList([self class], &count);

for (int i = 0; i < count; i++)
{
Ivar var = varArray[i];
const char *cName = ivar_getName(var); // 属性名c字符串
NSString *proName = [[NSString stringWithUTF8String:cName] substringFromIndex:1]; //OC字符串,并且去掉下划线 _
const char *cType = ivar_getTypeEncoding(var); // 获取变量类型，c字符串

id value = [self valueForKey:proName];
NSString *proType = [NSString stringWithUTF8String:cType]; // oc 字符串

if ([proType containsString:@"NSString"]) {
proType = stringType;
}
if ([proType containsString:@"NSNumber"]) {
proType = numberType;
}
if ([proType containsString:@"NSArray"]) {
proType = arrayType;
}
if ([proType containsString:@"UIImage"]) {
proType = imageType;
}

// (5). 根据类型进行编码
if ([proType isEqualToString:intType] || [proType isEqualToString:boolType] || [proType isEqualToString:BoolType]) {
[aCoder encodeInt32:[value intValue] forKey:proName];
}
else if ([proType isEqualToString:longTpye]) {
[aCoder encodeInt64:[value longValue] forKey:proName];
}
else if ([proType isEqualToString:floatType]) {
[aCoder encodeFloat:[value floatValue] forKey:proName];
}
else if ([proType isEqualToString:longlongType] || [proType isEqualToString:doubleType]) {
[aCoder encodeDouble:[value doubleValue] forKey:proName];
}
else if ([proType isEqualToString:stringType]) { // string 类型
[aCoder encodeObject:value forKey:proName];
}
else if ([proType isEqualToString:numberType]) {
[aCoder encodeObject:value forKey:proName];
}
else if ([proType isEqualToString:arrayType]) {
[aCoder encodeObject:value forKey:proName];
}
else if ([proType isEqualToString:imageType]) { // image 类型
[aCoder encodeDataObject:UIImagePNGRepresentation(value)];
}
}
free(varArray);
}
```

其次进行解档， 原理和归档差不多， 直接上代码
```//反归档，是一个解码的过程。
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
self = [self init];
if (self) {

unsigned int count;
Ivar *varArray = class_copyIvarList([self class], &count);

for (int i = 0; i < count; i++) {
Ivar var = varArray[i];
const char *cName = ivar_getName(var); // 属性名c字符串
NSString *proName = [[NSString stringWithUTF8String:cName] substringFromIndex:1]; //OC字符串,并且去掉下划线 _
const char *cType = ivar_getTypeEncoding(var); // 获取变量类型，c字符串
NSString *proType = [NSString stringWithUTF8String:cType]; // oc 字符串

if ([proType containsString:@"NSString"]) {
proType = stringType;
}
if ([proType containsString:@"NSNumber"]) {
proType = numberType;
}
if ([proType containsString:@"NSArray"]) {
proType = arrayType;
}
if ([proType containsString:@"UIImage"]) {
proType = imageType;
}

if ([proType isEqualToString:intType] || [proType isEqualToString:boolType] || [proType isEqualToString:BoolType]) {
int32_t number = [aDecoder decodeInt32ForKey:proName];
[self setValue:@(number) forKey:proName];
}
else if ([proType isEqualToString:longTpye]) {
int64_t number = [aDecoder decodeInt64ForKey:proName];
[self setValue:@(number) forKey:proName];
}
else if ([proType isEqualToString:floatType]) {
float number = [aDecoder decodeFloatForKey:proName];
[self setValue:@(number) forKey:proName];
}
else if ([proType isEqualToString:longlongType] || [proType isEqualToString:doubleType]) {
double number = [aDecoder decodeFloatForKey:proName];
[self setValue:@(number) forKey:proName];
}
else if ([proType isEqualToString:stringType]) { // string 类型
NSString *string = [aDecoder decodeObjectForKey:proName];
[self setValue:string forKey:proName];
}
else if ([proType isEqualToString:numberType]) {
NSString *number = [aDecoder decodeObjectForKey:proName];
[self setValue:number forKey:proName];
}
else if ([proType isEqualToString:arrayType]) {
NSArray *array = [aDecoder decodeObjectForKey:proName];
[self setValue:array forKey:proName];
}
else if ([proType isEqualToString:imageType]) { // image 类型
UIImage *image = [UIImage imageWithData:[aDecoder decodeDataObject]];
[self setValue:image forKey:proName];
}
}
}
return self;
}

```

最后也就是 存储方法 、 清除存储的本地缓存  和 获取本地存储数据的方法
```

//存储路径
- (NSString *)filePathWithUniqueFlagString:(NSString *)uniqueFlag
{
NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
NSString *detailPath = [NSString stringWithFormat:@"%@_%@",uniqueFlag,[NSString stringWithUTF8String:object_getClassName(self)]];
NSString *path = [docPath stringByAppendingPathComponent:detailPath];
return path;
}


//保存对象数据到本地
- (void)saveDataToLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey
{
[NSKeyedArchiver archiveRootObject:self toFile:[self filePathWithUniqueFlagString:uniqueFlagKey]];
}


//清空本地存储的对象数据
- (id)getDataFromLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey
{
return [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePathWithUniqueFlagString:uniqueFlagKey]];
}


//从本地获取对象数据
- (BOOL)removeDataFromLocalWithUniqueFlagKey:(NSString *)uniqueFlagKey
{
NSError *error = nil;
[[NSFileManager defaultManager] removeItemAtPath:[self filePathWithUniqueFlagString:uniqueFlagKey] error:&error];
if (!error) {
return YES;
}
else {
return NO;
}
}

```



