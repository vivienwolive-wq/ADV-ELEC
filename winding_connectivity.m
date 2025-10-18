function conn_total = winding_connectivity(Ns, p, nph, short_factor)
% WINDING_CONNECTIVITY  Generate the connectivity matrix for any winding
%
%   conn_total = winding_connectivity(Ns, p, nph, short_factor)
%
%   Ns            - total number of stator slots
%   p             - number of poles
%   nph           - number of phases (typically 3)
%   short_factor  - fractional coil pitch (e.g. 5/6)
%
%   Output: conn_total (nph x Ns)
%
%   Example - to run print this in the command window:
%       conn = winding_connectivity(12, 2, 3, 5/6)

    %% --- Basic checks ---
    q = Ns / (nph * p); % slots per pole per phase
    if mod(q,1) ~= 0
        error('q must be an integer. Adjust Ns, p, or nph.');
    end

    %% --- Generate base sequence (full pitch) ---
    % define phase order a, c, b repeating
    base_phases = {'a','b','c'};
    base_seq = cell(1, Ns);
    
    % build sequence for each pole pair
    phase_index = 1;
    for pole = 1:p
        for ph = 1:nph
            for slot = 1:q
                idx = (pole-1)*nph*q + (ph-1)*q + slot;
                if mod(pole,2) == 1
                    % positive pole
                    base_seq{idx} = base_phases{ph};
                else
                    % negative pole (reverse polarity)
                    base_seq{idx} = [base_phases{ph} ''''];
                end
            end
        end
    end

    %% --- Compute shift for shortening ---
    full_pitch = Ns / p;
    shift = round(full_pitch * (1 - short_factor));
    shift = mod(shift, Ns);

    %% --- Apply shortening (shift one layer) ---
    short_seq = circshift(base_seq, -shift);

    %% --- Build phase connection matrices ---
    conn_base = zeros(nph, Ns);
    conn_short = zeros(nph, Ns);

    for s = 1:Ns
        % Base layer
        phase = base_seq{s};
        conn_base = assign_phase(conn_base, phase, s);

        % Shortened (return side)
        phase = short_seq{s};
        conn_short = assign_phase(conn_short, phase, s);
    end

    %% --- Combine both layers ---
    conn_total = conn_base + conn_short;

    %% --- Display results ---
    fprintf('Ns = %d, p = %d, nph = %d, q = %.2f, shortening = %.3f\n', Ns, p, nph, q, short_factor);
    fprintf('Full-pitch sequence:\n%s\n', strjoin(base_seq, ' '));
    fprintf('Shortened sequence:\n%s\n', strjoin(short_seq, ' '));
    disp('Connectivity matrix (a,b,c rows; slot columns):');
    disp(conn_total);

    %% --- Compact Matlab literal (half-slot if symmetric) ---
    use_half = false;
    if mod(Ns,2) == 0
        first_half = conn_total(:, 1:Ns/2);
        second_half = conn_total(:, Ns/2+1:end);
        if isequal(first_half, second_half)
            use_half = true;
        end
    end
    if use_half
        literal = formatMatLiteral('Mat_C1', conn_total(:, 1:Ns/2));
        fprintf('Half-slot symmetry detected. Compact literal (first half):\n%s\n', literal);
    else
        literal = formatMatLiteral('Mat_C1', conn_total);
        fprintf('Compact literal (full matrix):\n%s\n', literal);
    end

    %% --- Visualization ---
    figure;
    imagesc(conn_total);
    colormap([1 1 1; 0 0 1; 1 0 0]);
    xlabel('Slot Number');
    ylabel('Phase');
    yticks(1:nph);
    yticklabels({'a','b','c'});
    title(sprintf('Connectivity Matrix: Ns=%d, p=%d, q=%.1f, Short=%.2f', Ns, p, q, short_factor));
    grid on;
end

%% --- Helper function for phase assignment ---
function mat = assign_phase(mat, phase, s)
    switch phase
        case 'a'
            mat(1,s) =  1;
        case "a'"
            mat(1,s) = -1;
        case 'b'
            mat(2,s) =  1;
        case "b'"
            mat(2,s) = -1;
        case 'c'
            mat(3,s) =  1;
        case "c'"
            mat(3,s) = -1;
    end
end

%% --- Helper: format matrix as Matlab literal ---
function literal = formatMatLiteral(name, M)
    [r, c] = size(M);
    rows = strings(r,1);
    for i = 1:r
        nums = arrayfun(@(x) sprintf('%.0f', x), M(i,:), 'UniformOutput', false);
        rows(i) = strjoin(nums, ' ');
    end
    indent = repmat(' ', 1, 15); % fixed indent for subsequent lines
    if r == 1
        body = rows(1);
        literal = sprintf('%s=[%s];', name, body);
    else
        parts = strings(r,1);
        parts(1) = sprintf('%s=[%s', name, rows(1));
        for i = 2:r
            parts(i) = sprintf('%s;%s', indent, rows(i));
        end
        closing = sprintf('];');
        literal = strjoin([parts; closing], '\n');
    end
end
