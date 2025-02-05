% SAMPLEROOMSETUP - Sample setup parameter structure for sofamyroom

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Steven Schimmel, stevenmschimmel@gmail.com
% adapted by: Roberto Barumerli, roberto.baru@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    room settings
%
room.dimension              = [ 10 7 4 ];   % room dimension (x,y,z)
room.humidity               = 0.42;         % relative humidity (0,...,1)
room.temperature            = 20;           % room temperature (celsius)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    surface absorption/diffusion coefficients
%
room.surface.frequency      = [  125       250       500       1000      2000      4000];
room.surface.absorption     = [  0.1000    0.0500    0.0600    0.0700    0.1000    0.1000;
                                 0.1400    0.3500    0.5300    0.7500    0.7000    0.6000;
                                 0.1000    0.0500    0.0600    0.0700    0.1000    0.1000;
                                 0.1000    0.0500    0.0600    0.0700    0.1000    0.1000;
                                 0.0100    0.0200    0.0600    0.1500    0.2500    0.4500;
                                 0.2400    0.1900    0.1400    0.0800    0.1300    0.1000 ];
room.surface.diffusion      = [  0.5       0.5       0.5       0.5       0.5       0.5   ; 
                                 0.5       0.5       0.5       0.5       0.5       0.5   ; 
                                 0.5       0.5       0.5       0.5       0.5       0.5   ; 
                                 0.5       0.5       0.5       0.5       0.5       0.5   ; 
                                 0.5       0.5       0.5       0.5       0.5       0.5   ; 
                                 0.5       0.5       0.5       0.5       0.5       0.5    ];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    simulation options
%
options.fs                  = 44100;                % sampling frequency in Hz
options.responseduration    = 1.25;                 % duration of impulse response
options.bandsperoctave      = 1;                    % simulation frequency accuracy (1, 2, 3, or 4 bands/octave)
options.referencefrequency  = 125;                  % reference frequency for frequency octaves
options.airabsorption       = true;                 % apply air absorption?
options.distanceattenuation = true;                 % apply distance attenuation?
options.subsampleaccuracy   = false;                % apply subsample accuracy?
options.highpasscutoff      = 0;                    % 3dB frequency of high-pass filter (0=none)
options.verbose             = true;                 % print status messages?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    specular reflections simulation options
%
options.simulatespecular    = true;                 % simulate specular reflections?
options.reflectionorder     = [ 10 10 10 ];         % maximum specular reflection order (x,y,z)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    diffuse reflections simulation options
%
options.simulatediffuse     = false;                 % simulate diffuse reflections?
options.numberofrays        = 2000;                 % number of rays in simulation (20*K^2)
options.diffusetimestep     = 0.010;                % time resolution in diffuse energy histogram (seconds)
options.rayenergyfloordB    = -80;                  % ray energy threshold (dB, with respect to initial energy)
options.uncorrelatednoise   = true;                 % use uncorrelated poisson arrivals for binaural impulse responses?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    output options
%
options.outputname			= 'output';           	% name of the output file
options.mex_saveaswav       = false;                % enable or disable saving the results of sofamyroom on disk
                                                    % when using MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    source definitions
%
source(1).location           = [ 8 2.5 1.6 ];       % location of source (x,y,z; meters)
source(1).orientation        = [ 180 0 0 ];         % orientation of source (yaw,pitch,roll; degrees)
source(1).description        = 'subcardioid';       % source type

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    receiver definitions
%
receiver(1).location         = [ 3 5 1.2 ];         % location of receiver (x,y,z; meters)
receiver(1).orientation      = [ 0 0 0 ];           % orientation of receiver (yaw,pitch,roll; degrees)
receiver(1).description      = 'SOFA MIT_KEMAR_normal_pinna.sofa';  % receiver type

