function [X,mm] = momi(X)
mm = [min(X(:)),max(X(:))];
X = (X-mm(1))./diff(mm);