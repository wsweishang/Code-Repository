#!/usr/bin/python3
#coding:utf-8
#2021-10-08

########################################058_类与实例########################################
#类是多个类似事物组成的群体的统称，不同的数据类型属于不同的类
#例如一组大小不同的圆都是圆这一类之下相似的不同个例，这样的每一个个例称为实例或对象
#类的组成：实例属性、类属性、实例方法、类方法、静态方法
#实例属性：每个实例分别具有的属性，例如每个圆的直径
#类属性：类中所有实例共有的属性，例如圆周率Π
#方法：在类中定义的函数

class student :
    native_place = "home place" #类属性
    
    def __init__ (self, name, age) :
        self.name = name #self.name称为实例属性，通过进行赋值操作将局部变量的name赋值给实例属性
        self.age = age
    
    def eat (self) : #实例方法
        print("eating launch")
    
    @staticmethod
    def static_method () : #静态方法
        print("doing staticmethod")
    
    @classmethod
    def class_method (cls) : #类方法
        print("doing classmethod")
    
print(student, type(student), id(student))


class Circle (object) :
    pi = 3.14  # 类属性
    
    def __init__(self, r) :
        self.r = r # 半径为实例属性

circle1 = Circle(1)
circle2 = Circle(2)
print('----未修改前-----')
print('pi =', Circle.pi)
print('circle1.pi =', circle1.pi)  #  3.14
print('circle2.pi =', circle2.pi)  #  3.14
print('----通过类名修改后-----')
Circle.pi = 3.14159  # 通过类名修改类属性，所有实例的类属性被改变
print('pi =', Circle.pi)   #  3.14159
print('circle1.pi =', circle1.pi)   #  3.14159
print('circle2.pi =', circle2.pi)   #  3.14159
print('----通过circle1实例名修改后-----')
circle1.pi=3.14111   # 实际上这里是给circle1创建了一个与类属性同名的实例属性
print('pi =', Circle.pi)     #  3.14159
print('circle1.pi =', circle1.pi)  # 实例属性的访问优先级比类属性高，所以是3.14111   
print('circle2.pi =', circle2.pi)  #  3.14159
print('----删除circle1实例属性pi-----')


# 新型一个新型类SweetPotato
class SweetPotato(object):
    '''
    烤地瓜的文档说明内容
    '''
    # 初始化属性CookeLevel(一共烤的时间)，CookedString(地瓜状态)，Condiments(调料列表)
    def __init__(self):
        self.CookedLevel = 0
        self.CookedString = '生的'
        self.Condiments = []
    # 烤地瓜的方法
    def cook(self,time):
        self.CookedLevel += time
        if self.CookedLevel > 8:
            self.CookedString = '烤糊了'
        elif self.CookedLevel > 5:
            self.CookedString = '烤好了'
        elif self.CookedLevel > 3:
            self.CookedString = '烤的半生不熟'
        else:
            self.CookedString = '生的'
    # 添加调料的方法
    def add_condiments(self,condiments):
        self.Condiments.append(condiments)
    # print的输出信息
    def __str__(self):
        if len(self.Condiments) > 0:
            str_Condiments = ','.join(self.Condiments)
            return '地瓜烤了%d分钟，%s,调料是%s' % (self.CookedLevel,self.CookedString,str_Condiments)
        else:
            return '地瓜烤了%d分钟，%s,没有调料' % (self.CookedLevel, self.CookedString)
 
print(SweetPotato.__doc__) # 查看类的文档说明：烤地瓜的文档说明
mysweetpotao = SweetPotato() # 实例化一个对象
mysweetpotao.cook(2)
print(mysweetpotao) # 地瓜烤了2分钟，生的,没有调料
 
mysweetpotao.cook(2)
mysweetpotao.add_condiments('番茄酱')
print(mysweetpotao)# 地瓜烤了4分钟，烤的半生不熟,调料是番茄酱
 
mysweetpotao.cook(4)
mysweetpotao.add_condiments('辣椒酱')
print(mysweetpotao) # 地瓜烤了8分钟，烤好了,调料是番茄酱,辣椒酱
 
mysweetpotao.cook(2)
mysweetpotao.add_condiments('芥末')
print(mysweetpotao) #地瓜烤了10分钟，烤糊了,调料是番茄酱,辣椒酱,芥末







































