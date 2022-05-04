function data = RDC_extract_awr2243(fNameIn)
    fileID = fopen(fNameIn, 'r'); % open file
    data = fread(fileID, 'int16');% DCA1000 should read in two's complement data
    fclose(fileID); % close file
    
    fileSize = size(data, 1);
    numRX = 4;
    NTS = 256; %64 Number of time samples per sweep
    isTDM = 0;
    isBPM = 1;
    
    numChirps = ceil(fileSize/2/NTS/numRX);
    
    % zero pad
    zerostopad = round(NTS * numChirps * numRX * 2 - length(data));
    data = cat(1, data, zeros(zerostopad,1));

    % Organize data per RX
    data = reshape(data, numRX * 2, []);
    data = data(1:4, :) + data(5:8, :) * 1j;
    data = data.';
    data = reshape(data, NTS, numChirps, numRX);

    % if BPM and TDM enabled
    
    if isBPM && ~isTDM
            rem = mod(size(data,2), 2);
            if rem ~= 0
                    data = data(:, 1:end-rem, :);
            end
            chirp1 = 1/2 * (data(:, 1:2:end, :) + data(:, 2:2:end, :));
            chirp2 = 1/2 * (data(:, 1:2:end, :) - data(:, 2:2:end, :));
            data = cat(3, chirp1, chirp2);
    end
    
%     if isTDM && isBPM
%         prf = 1 / params['dT'] / params['numTX']
%         rem = -(data.shape[1] % 3)
%         if rem:
%             data = data[:, :rem, :]
%         end
%         chirp1 = 1/2 * (data[:, 0::3, :] + data[:, 1::3, :])
%         chirp2 = 1/2 * (data[:, 0::3, :] - data[:, 1::3, :])
%         chirp3 = data[:, 2::3, :]
%         data = np.concatenate([chirp1, chirp2, chirp3], -1)
%     end
% 
%     if params['isTDM'] and not params['isBPM']:
%         prf = 1 / params['dT'] / params['numTX']
%         rem = -(data.shape[1] % 3)
%         if rem:
%             data = data[:, :rem, :]
%         chirp1 = data[:, 0::3, :]
%         chirp2 = data[:, 1::3, :]
%         chirp3 = data[:, 2::3, :]
%         data = np.concatenate([chirp1, chirp2, chirp3], -1)
    
    
    
end