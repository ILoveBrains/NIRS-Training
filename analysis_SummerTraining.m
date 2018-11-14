clear

%% load

root = '/Users/erikarnold/Downloads';
raw  = nirs.io.loadDirectory( [root filesep 'Summer Training'], {'subject', 'scan'} );
%% preprocessing

%%Jessica's merge condition code

% Question from Jessica: this way you are keeping 9 conditions, but later you specify durations for 8.
% Which conditions are to be merged?

j = nirs.modules.KeepStims();
 j.listOfStims = { 'channel_1', 'channel_2', 'channel_3', ...
    'channel_5', 'channel_6', 'channel_7', 'channel_9', 'channel_10', ...
    'channel_11', 'channel_12'};
rawEdited = j.run(raw);
% raw_editedConditions= j.run(raw);
% raw_editedDurations= nirs.design.change_stimulus_duration(raw_editedConditions, 'channel_2', 4);


%%Jessica's edit duration code
durationCondition1= 2;
durationCondition2= 4;
durationCondition3= 2;
durationCondition5= 50;
durationCondition6= 20;
durationCondition7= 50;
durationCondition9= 2;
durationCondition10= 2;
durationCondition11= 2;
durationCondition12= 2;

rawEdited= nirs.design.change_stimulus_duration(rawEdited, 'channel_1', durationCondition1);
rawEdited= nirs.design.change_stimulus_duration(rawEdited, 'channel_2', durationCondition2);
rawEdited= nirs.design.change_stimulus_duration(rawEdited, 'channel_3', durationCondition3);
rawEdited= nirs.design.change_stimulus_duration(rawEdited, 'channel_5', durationCondition5);
rawEdited= nirs.design.change_stimulus_duration(rawEdited, 'channel_6', durationCondition6);
rawEdited= nirs.design.change_stimulus_duration(rawEdited, 'channel_7', durationCondition7);
rawEdited= nirs.design.change_stimulus_duration(rawEdited, 'channel_9', durationCondition9);
rawEdited= nirs.design.change_stimulus_duration(rawEdited, 'channel_10', durationCondition10);
rawEdited= nirs.design.change_stimulus_duration(rawEdited, 'channel_11', durationCondition11);
rawEdited= nirs.design.change_stimulus_duration(rawEdited, 'channel_12', durationCondition12);


%% Changed by Jessica from j = nirs.modules.RemoveStimless(j) to j = nirs.modules.RemoveStimless();
%% Whenever a "job" j is run (like in line 15), is must be re-initialized as empty () insted of concatenated with the previous one (j)
%% Then, you can concatenate them again (from line 52 and on) until you run it.
j = nirs.modules.RemoveStimless();
j = nirs.modules.RenameStims( j );
%%Changing stim conditions to normal names
j.listOfChanges = {
    'channel_1', 'Rest';
    'channel_2', 'Cake';
    'channel_3', 'Wait';
    'channel_5', 'BlockNeg';
    'channel_6', 'Blockrest';
    'channel_7', 'BlockPos';
    'channel_9', 'FeedbackNeg';
    'channel_10', 'FeedbackPos';
    'channel_11' 'HowFeelNeg';
    'channel_12', 'HowFeelPos'};

%%Or...changing stim conditions to block names
% j.listOfChanges = {
%     'channel_1', 'Block';
%     'channel_2', 'Block';
%     'channel_3', 'Block';
%     'channel_4', 'Block';
%     'channel_5', 'HowFeel';
%     'channel_6', 'Block';
%     'channel_8', 'Block'};


j = nirs.modules.Resample(j);
j.Fs = 4;
j = nirs.modules.TrimBaseline( j );
j.preBaseline  = 30;
j.postBaseline = 30;
j = nirs.modules.OpticalDensity( j );
j = nirs.modules.BeerLambertLaw( j );

hb = j.run(rawEdited);


%% check data for QA
% Here you can click through the files and also click on the probe to see
% specific channels.
nirs.viz.TimeSeriesViewer( hb )

%%Making time a regressor
demographics = nirs.createDemographicsTable(raw);
%% makes sure numbers match your sample (e.g. 10 if 10 total scans)
for idx=1:2:6


    rawEdited(idx).demographics('session')=0;   % making this numeric allows us to use it as a regressor
    rawEdited(idx+1).demographics('session')=1; % otherwise strings will be catagorical


end
%% subject level
j = nirs.modules.AR_IRLS();

j.verbose    = true;
j.trend_func = @(t) nirs.design.trend.legendre(t, 0);

S = j.run( hb );



%%No demo table yet
% data_folder = [root filesep 'LEAF'];
% demo_file   = [root filesep 'FileName.xlsx']
% demo_table = readtable(demo_file);
% demo_table.subject = cellfun(@(x){num2str(x)}, demo_table.subject);
% %demotable.Subject = arrayfun(@(x){num2str(x)}, demotable.Subject);
% %demotable.Subject = bsxfun(@(x){num2str(x)}, demotable.Subject);
% j=nirs.modules.AddDemographics;
% j.varToMatch    = 'subject';
% j.demoTable=demo_table;
% S=j.run(S);

j = nirs.modules.MixedEffects( );
j.centerVars = true;
%If want to run mixed effects model with a demographics variable, run the
%below line and comment out the other model
% If you want to just run the condition contrasts, run below line and
% comment out above model
j.formula = 'beta ~ -1 + session:cond + (1|subject)';
j.dummyCoding = 'full';
j.include_diagnostics=true;
G= j.run (S);

G.draw('tstat',[-5 5],'p<0.05');
