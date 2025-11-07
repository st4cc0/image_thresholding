function segmented_edges = segment_image(img_gray, k_cluster, lower_area)
    % SEGMENT_IMAGE Function to segment edges in a grayscale image using K-means clustering
    %
    % Input Arguments:
    %     img_gray   - Input grayscale image
    %     k_cluster  - Number of K-means clusters (default: 7)
    %     lower_area - Minimum area threshold for components (default: 10 px)
    %
    % Output Arguments:
    %     segmented_edges - Binary mask of the segmented edges

    arguments
        img_gray       {mustBeNumeric}        % Input grayscale image
        k_cluster      (1,1) double = 7       % Number of K-means clusters (default: 7)
        lower_area     (1,1) double = 10      % Min area threshold for components (default: 10 px)
    end

    % Calculate gradient magnitude using central differences
    % [edges, ~] = imgradient(img_gray, 'central');
    edges = img_gray;

    % ------------------------
    % Step 2: K-means clustering on edge strengths
    % ------------------------
    % Cluster edge magnitudes into k_cluster groups (2 attempts for stability)
    % k_means_edge: labeled image, centers: mean edge value per cluster
    [k_means_edge, centers] = imsegkmeans(single(edges), k_cluster, 'NumAttempts', 2);

    % ------------------------
    % Step 3: Select the top-N strongest edge clusters
    % ------------------------
    N_strongest_edges = round(0.7*k_cluster);            % Number of strongest clusters to keep
    [~, k_sorted] = sort(centers, 'ascend');             % Sort clusters by center strength
    strongest_edges = k_sorted(end:-1:end-N_strongest_edges+1);  % IDs of top-N clusters
    segmented_edges = ismember(k_means_edge, strongest_edges);  % Binary mask of those clusters

    % ------------------------
    % Step 4: Clean and fill segmented regions
    % ------------------------
    segmented_edges = bwareafilt(segmented_edges, [lower_area, inf]);  % Remove small blobs
    hole_fill = 3;  % Variable to determine hole filling method
    switch hole_fill
        case 1
            segmented_edges = imfill(segmented_edges, 'holes');               % Fill interior holes
        case 2
            %--dilate edges
            dilate_se = strel("diamond",2);  % Structuring element for dilation
            segmented_erode = imdilate(segmented_edges,dilate_se);
            %--erode
            erode_se = [0 0 0 1 0 0 0;1 1 1 1 1 1 1;0 0 0 1 0 0 0];  % Structuring element for erosion
            % erode_se = [0 1 0 ; 1 1 1 ; 0 1 0 ];
            segmented_edges = imerode(segmented_erode,erode_se);
        case 3
            %no filling
    end
end
