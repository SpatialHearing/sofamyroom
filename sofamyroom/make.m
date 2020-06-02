function make(varargin)
% MAKE Build sofamyroom project
%   MAKE without arguments builds the sofamyroom project and updates the
%   sofamyroom function in MATLAB.
%
%   MAKE TEST builds the unit tests of the sofamyroom project and updates the
%   sofamyroomTEST function in MATLAB.

%Check MATLAB version
[~, maxArraySize] = computer; 
is64bitComputer = maxArraySize > 2^31;
if ~is64bitComputer
    fprintf("Building of Sofamyroom is not supported on 32-bit MATLAB\n");
    return
end

% Version
version = '1.0';

% MEX-file name
output = 'sofamyroom';

% Set default switches
 switches = {'-DMEX'
             '-DLOGLEVEL=0'
             '-DMEXP=19937'
             ['-Isource' filesep 'libroomsim' filesep 'include']
             ['-Isource' filesep 'libsfmt']
             ['-Isource' filesep 'wavwriter' filesep 'include']
           };
       
if ispc
    switches =  [switches
                ['-Isource' filesep 'libfftw' filesep 'Windows' filesep 'x64' filesep 'include']
                ['-Isource' filesep 'libmysofa' filesep 'Windows' filesep 'x64' filesep 'include']
                ];
            
elseif ismac
    switches = [switches
               ['-Isource' filesep 'libfftw' filesep 'MacOS' filesep '64bit' filesep 'include']
               ['-Isource' filesep 'libmysofa' filesep 'MacOS' filesep '64bit' filesep 'include']
               ];
            
elseif isunix
    switches = [switches
               ['-Isource' filesep 'libmysofa' filesep 'Linux' filesep '64bit' filesep 'include']
               ];
end

% Process optional arguments
debug = false;
for i = 1:nargin
    switch varargin{i}
        case 'test'
            switches = [switches
                        '-DUNIT_TEST'
                        '-g'
                        ];
            output = 'sofamyroomtest';
        case 'debug'
            switches = [switches 
                        '-g'
                        ];
            debug = true;
        otherwise
            switches = [switches 
                        varargin{i}
                        ];
    end
end

% Set options
options = {};

if ispc
    options = [options
               ['-Lsource' filesep 'libfftw' filesep 'Windows' filesep 'x64' filesep 'lib']
               '-lfftw3-3.lib'
               ];
    if ~debug
        options = [options
                  ['-Lsource' filesep 'libmysofa' filesep 'Windows' filesep 'x64' filesep 'lib' filesep 'Release']
                  '-lmysofa'
            ];
    else
        options = [options
                  ['-Lsource' filesep 'libmysofa' filesep 'Windows' filesep 'x64' filesep 'lib' filesep 'Debug']
                  '-lmysofad'
                  ];
    end
    
elseif ismac
    if ~debug
        options = [options
                  ['-Lsource' filesep 'libmysofa' filesep 'MacOS' filesep '64bit' filesep 'lib' filesep 'Release']
                  '-lmysofa'
                  ['-Lsource' filesep 'libfftw' filesep 'MacOS' filesep '64bit' filesep 'lib' filesep 'Release']
                  '-lfftw3'
            ];
    else
        options = [options
                  ['-Lsource' filesep 'libmysofa' filesep 'MacOS' filesep '64bit' filesep 'lib' filesep 'Debug']
                  '-lmysofad'
                  ['-Lsource' filesep 'libfftw' filesep 'MacOS' filesep '64bit' filesep 'lib' filesep 'Debug']
                  '-lfftw3d'
                  ];
    end
    options = [options
              "-lz"
               ];
    
elseif isunix
    if ~debug
        options = [options
                  ['-Lsource' filesep 'libmysofa' filesep 'Linux' filesep '64bit' filesep 'lib' filesep 'Release']
                  '-lmysofa'  
                  ];
    else
        options = [options
                  ['-Lsource' filesep 'libmysofa' filesep 'Linux' filesep '64bit' filesep 'lib' filesep 'Debug']
                  '-lmysofad'
                  ];
    end
    options = [options
               '-lz'
               '-lfftw3'
              ];
end

mexfiles = { ['source' filesep 'libroomsim' filesep 'source' filesep '3D.c']
             ['source' filesep  'libroomsim'  filesep  'source'  filesep  'dsp.c']
             ['source' filesep  'libroomsim'  filesep  'source'  filesep  'interface.c']
             ['source' filesep  'libroomsim'  filesep  'source'  filesep  'interp.c']
             ['source' filesep  'libroomsim'  filesep  'source'  filesep  'roomsim.c']
             ['source' filesep  'libroomsim'  filesep  'source'  filesep  'rng.c']
             ['source' filesep  'libroomsim'  filesep  'source'  filesep  'sensor.c']
             ['source' filesep  'libsfmt'  filesep  'SFMT.c']
             ['source' filesep  'mexmain.c']
             ['source' filesep  'build.c']
             ['source' filesep  'wavwriter' filesep 'source' filesep 'wavwriter.c']
           };

% Remove sofamyroom from memory, if loaded
clear sofamyroom;

% Echo command to be executed
fprintf('mex '); 
fprintf('%s ', switches{:});
fprintf('-output %s ', output);
fprintf('%s ', mexfiles{:});
fprintf('%s ', options{:});
fprintf('\n');

% Run MEX to build the desired target
mex(switches{:}, '-output', output, mexfiles{:}, options{:})

% Copy libfftw3-3.dll into working directory, Windows only
if ispc
    [status, msg] = copyfile(...
        ['source' filesep 'libfftw' filesep 'Windows' filesep 'x64' filesep 'bin' filesep 'libfftw3-3.dll']...
    );
    if ~status
        fprintf("An error occured while copying libfftw3-3.dll file: %s\n", msg)
    else
        fprintf("libfftw3-3.dll successfully copied.\n")
    end
end

% Creating zip archive
distribfiles = { 'sampleroomsetup.m'
                 'editabsorption.m'
                 'estimateroombreakfreq.m'
                 'estimateRT60.m'
                 'plotabsorption.m'
                 'plotbrir.m'
                 'plotcoordsystem.m'
                 'plotroom.m'
                 'readsetup.m'
                 'rsound.m'
                 'selectabsorption.m'
                 'setcomplexity.m'
                 'yprTs2r.m'
                 'yprTr2s.m'
                 [output '.' mexext]
               };
           
if ispc
    distribfiles = [ distribfiles
                     'libfftw3-3.dll'
                    ];
end

zip(['sofamyroom_v' version '_' date '.zip'], distribfiles)

fprintf("Zip archive successfully created.\n")
