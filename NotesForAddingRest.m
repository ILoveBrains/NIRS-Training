%get the starting of the 1st trigger and set

rawEdited(subject,dataset).stimulus.values{1, 5}.

rawEdited(subject,dataset).stimulus.values{1, 2}.onset(1)

c1=

a = rawEdited(3, 1).stimulus.values{1, 2}.onset(1)
 -1 %offest of the timing
c1 = {0}
b = {}

a = [c1;a]
b = cell2mat(a)
w = num2cell(a,1)
rawEdited(3, 1).stimulus.values{1, 5}.onset = w
