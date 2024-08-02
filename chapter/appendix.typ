#import "../template/template.typ": *

#let code1 = ```matlab
clc,clear,close all
%理论培训时间与参加人数关系
x1 = table2array(readtable("C3.xlsx","Range","A2:A11"));
y1 = table2array(readtable("C3.xlsx","Range","D2:D11"));
scatter(x1,y1,'filled');
[b,bint,r,rint,stats]=regress(y1,[ones(10,1),x1,(x1.^2)])
rcoplot(r,rint);
x1(10,:)=[];
y1(10,:)=[];
[b,bint,r,rint,stats]=regress(y1,[ones(9,1),x1,(x1.^2)])
rcoplot(r,rint);
%实践培训时间与参加人数关系
x2 = table2array(readtable("C3.xlsx","Range","B12:B21"));
y2 = table2array(readtable("C3.xlsx","Range","D12:D21"));
scatter(x2,y2,'filled');
y2(2)=(y2(1)+y2(3))/2;
scatter(x2,y2,'filled');
[b,bint,r,rint,stats]=regress(y2,[ones(10,1),x2,(x2.^2)])
rcoplot(r,rint);
y2(5)=(y2(4)+y2(6))/2;
y2(9)=(y2(8)+y2(10))/2;
[b,bint,r,rint,stats]=regress(y2,[ones(10,1),x2,(x2.^2)])
rcoplot(r,rint);
%投入与参加人数关系
x3 = table2array(readtable("C3.xlsx","Range","C22:C31"));
y3 = table2array(readtable("C3.xlsx","Range","D22:D31"));
scatter(x3,y3,'filled');
hold on
ft = fittype( 'rat11' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.237910506100943 0.558026701756326 0.299620025432728];
[fitresult, gof] = fit( x3, y3, ft, opts );
```

#let code2 =```matlab
clc,clear,close all
data = table2array(readtable("C3.xlsx","Range","A2:D31"));  %导入数据
std=y1(7);
%理论培训时间与参加人数回归分析
x1 = data(1:10,1);
y1 = data(1:10,4);
for i = 1:10
    y1(i)=std-y1(i);
end
scatter(x1,y1,'filled');
hold on
ft = fittype( 'poly2' );
[fitresult, gof] = fit( x1, y1, ft );
plot( fitresult, x1, y1 );
xlabel( 'x1');
ylabel( 'y1');
legend(["x1",""])
grid on
hold off
%实践培训时间与参加人数回归分析
x2 = data(11:20,2);
y2 = data(11:20,4);
for i = 1:10
    y2(i)=std-y2(i);
end
y2(2)=(y2(1)+y2(3))/2;
scatter(x2,y2,'filled');
hold on
r=polyfit(x2,y2,2);
t=0:1:400;
yy = r(1)*t.^2+r(2).*t+r(3);
plot(t,yy,'-');
grid on
hold off
%投入与参加人数回归分析
x3 = data(21:30,3);
y3 = data(21:30,4);
for i = 1:10
    y3(i)=std-y3(i);
end
scatter(x3,y3,'filled');
hold on
ft = fittype( 'rat11' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.350727103576883 0.939001561999887 0.875942811492984];
[fitresult, gof] = fit( x3, y3, ft, opts );
h = plot( fitresult, x3, y3 );
xlabel( 'x3');
ylabel( 'y3');
legend(["x3",""])
grid on
hold off
%回归方程检验
y = data(:,4);
t=1:1:30;
hold on
y = data(1:30,4);
y(12)=(y(11)+y(13))/2;
sst=0; %SST
for i = 1:30
    sst=sst+(y(i)-sum(y)./30)^2;
end
ssr=0; %SSR
for i = 1:30
    ssr=ssr+(yf(x1(i),x2(i),x3(i))-sum(y)./30)^2;
end
sse=0; %SSE
for i = 1:30
    sse=sse+(y(i)-yf(x1(i),x2(i),x3(i))).^2;
end
rsquare=1-sse/sst   %相关系数检验

msr=ssr/(3-1);
mse=sse/(30-3);
f=msr/mse   %f检验
```

#let code3 = ```matlab
function t = yf(i,j,k)
    t=45.15-(0.0003392*i.^2-0.1969*i+28.4 ...
      +0.0001212184355522038*j.^2-0.064028817370481.*j+9.417872659555059+...
      (-3.829*k+2082)./(k+85.62));
end
```

#let code4 = ```matlab
clc,clear,close all

w=0.5;      % 惯性
c1 = 0.8;     % 个体经验
c2 = 0.9;     % 社会经验
maxg = 500;   % 迭代次数
N = 600;      % 粒子数
Vmax = 1;     % 速度范围
Vmin = -1;     
Xmax = 800;   %变量取值范围
Xmin = 0;
dim = 3;      %函数表达式的自变量个数
for i=1:N
    location(i,:)=Xmax*abs(rands(1,dim));    %初始化坐标
    V(i,:)=Vmax*rands(1,dim);           %初始化速度
    fitness(i)=yf(location(i,1),location(i,2),location(i,3));     %适应度
end
[fitnessgbest,bestindex]=max(fitness);%fitnessgbest是全局最优解对应的适应度
gbest=location(bestindex,:);   %全局最优解
pbest=location;                %所有粒子的个体最优解
fitnesspbest=fitness;          %所有粒子的个体最优解对应的适应度
for i=1:maxg
    for j=1:N
        % 根据惯性、个体最优pbest和群体最优gbest并更新速度
        V(j,:) = w*V(j,:) + c1*(pbest(j,:) - location(j,:)) + c2*(gbest - location(j,:)); 
        for k = 1:dim    % 限制速度不能过大
            if V(j,k) > Vmax
                V(j,k) = Vmax*0.9;
            elseif V(j,k) < Vmin
                V(j,k) = Vmin*0.9;
            end
        end 
        location(j,:) = location(j,:) + V(j,:); % 更新位置 
        for k = 1:dim      % 限制位置不能超过边界
            if location(j,k) > Xmax
                location(j,k) = Xmax*0.9;
            elseif location(j,k) < Xmin
                location(j,k) = Xmin*0.9;
            end
            if location(j,3) > 700
                location(j,3) = 650;
            end
        end 
        %更新第j个粒子的适应度值
        fitness(j) = yf(location(j,1),location(j,2),location(j,3)); 
    end
    for j = 1:N 
        if fitnesspbest(j) < fitness(j)    %更新个体最优解
            pbest(j,:) = location(j,:);
            fitnesspbest(j) = fitness(j);
        end 
        if fitnessgbest < fitness(j)    %群体最优更新
            gbest = location(j,:);
            fitnessgbest = fitness(j);
        end
    end 
    yy(i) = fitnessgbest;    
end
figure;
plot(yy)
title('群体最优适应度','fontsize',12);
xlabel('迭代代数','fontsize',18);ylabel('适应度','fontsize',18);
```

#let codeZip=(
  "B31.m第一问求解每个因素与参加人数的关系": code1,
  "B32.m 第二问求解总体回归方程模型": code2,
  "yf.m 第二问回归函数": code3,
  "PSO.m 粒子群算法求解最大值": code4
)

= 附录
#for (desc,code) in codeZip{
    codeAppendix(
        code,
        caption: desc
    )
    v(2em)
}