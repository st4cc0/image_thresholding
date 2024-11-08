function entropy_thresh  = max_entropy_thresh(image)
[counts,edges] = histcounts(image(:),2^8);
intensities = 0.5*(edges(1:end-1)+edges(2:end));
entropy_t = zeros(length(edges),1);

for i=1:length(edges)-1

    counts_a = counts(1:i)./sum(counts(1:i));
    counts_b = counts(i:end)./sum(counts(i:end));


    entropy_a = -sum(counts_a.*log(counts_a+eps));
    entropy_b = -sum(counts_b.*log(counts_b+eps));

    entropy_t(i) = entropy_a + entropy_b;
end

[~,idx] = max(entropy_t);
entropy_thresh = intensities(idx);
end
