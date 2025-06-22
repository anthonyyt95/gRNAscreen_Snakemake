%% Combine count files

parent = 'E:\Documents\NYU\NYU Langone\PhD\Feske Lab\Experiments\06.26.18_Misc\2021.02.23_TumorScreenAnalysis\2021.06.11_CRISPRscreen\counts';
%gRNAlist = input;

% Combines files
files = dir(parent);
countOut = [];
gRNAOut = {};
sampOut = {};
for i = [1:length(files)]
    fileName = files(i).name;
    
    loc = strfind(fileName,'.txt');
    if isempty(loc)
        continue
    end
    
    address = [parent,'\',fileName];
    data = importdata(address);
    data(1,:) = [];
    gRNAs = {};
    counts = [];
    for j = [1:length(data(:,1))]
        val = data{j,1};
        val = strtrim(val);
        val = strsplit(val,' ');
        
        counts = [counts; str2num(cell2mat(val(1)))];
        gRNAs = [gRNAs; val(2)];
    end
    

    fileName = strsplit(fileName,'.');
    fileName = fileName{1};
    
    % Finds each gene in gene list
    val = repelem(0,length(gRNAlist))';
    for j = [1:length(gRNAlist(:,1))]
        loc = find(strcmp(lower(gRNAs),lower(gRNAlist{j,1})));
        if not(isempty(loc))
            val(j,1) = counts(loc,1);
        end
    end
    
    countOut = [countOut, val];
    sampOut = [sampOut, fileName];
end

% Acquires genes
gRNAlist = gRNAlist(:,1);
genesOut = {};
for i = [1:length(gRNAlist(:,1))]
    gene = strsplit(gRNAlist{i,1},'_');
    gene = gene{1};
    genesOut = [genesOut; gene];
end

heading = ['Guide','Gene',sampOut];
output = [gRNAlist, genesOut,num2cell(countOut)];
output = [heading; output];

xlswrite('output.xlsx', output);
display('end')

clear address countOut counts data fileName files gRNA gRNAOut i loc parent 
clear sampOut heading output genesOut gene gRNAlist gRNAs j val

%% LPS prelim. screen summary + figures

data = input;
list1 = pos1;
list2 = neg;
list3 = pos2;

genes = data(:,1);
metric1 = cell2mat(data(:,8));
metric2 = -log10(cell2mat(data(:,4)));
%metric = -log2(metric+1);

figure
hold
xval = 1:length(data(:,1));
s = scatter(metric1,metric2,'o');
s.MarkerEdgeColor = [0 0 0];
s.MarkerFaceColor = [0.5 0 0];
s.MarkerFaceAlpha = 0.3;
s.SizeData = 50;
set(gca,'LineWidth',2);
set(gca,'FontSize',30);
set(gca,'TickDir','out');
xlim([-2,1]);


%% Histogram of counts

fileName = 'E:\Documents\NYU\NYU Langone\PhD\Feske Lab\Experiments\03.31.19_ICT Analysis\Data\2020.10.01_AdjunctLibraryCloning\NGSdata\2020.11.24\NGScounts\C3-2_S3_L001_R1_001.counts.txt';

figure
hold
data = readtable(fileName);
data(1,:) = [];
data = table2cell(data);
gRNAs = data(:,2);
data = data(:,1);
data = cell2mat(data);
data = log10(data+1);
h = histogram(data,100);
h.FaceColor = [0.5 1 0.5];
h.FaceAlpha = 0.6;

set(gca,'FontSize',13);
set(gca,'TickDir','out');
set(gca,'LineWidth',2);


%% Correlations between count files

a = data2;
b = data3;

a = log10(a+1);
b = log10(b+1);
[rho p] = corr(a,b);
scatter(a,b,'o');

%%

preface = '30M';
names = input;

for i = [1:length(names)]
    name = names{1,i};
    name = [preface,'_',name];
    names{1,i} = name;
end

