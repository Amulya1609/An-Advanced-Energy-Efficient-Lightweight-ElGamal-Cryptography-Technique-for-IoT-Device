close all;
%clc;

m = 15;
q = 2^m;

poly = primpoly(m,'nodisplay');

primeFactors = unique(factor(2^m-1));
rng(123456);
while 1
    g = gf(randi([1,q-1]),m,poly);
    isPrimitive = true;
    for i = 1:length(primeFactors)
        if g^((q-1)/primeFactors(i)) == gf(1,m,poly)
            isPrimitive = false;
            break;
        end
    end
    if isPrimitive
        break;
    end
end

privateKey = 12;
publicKey = {g,g^privateKey,poly};
disp(publicKey)
disp(poly)

text = 'Cryptography';
disp(text);

bitsPerChar = 7;
binMsg = int2bit(int8(text'),bitsPerChar);
numPaddedBits = m - mod(numel(binMsg),m);
if numPaddedBits == m
    numPaddedBits = 0;
end
binMsg = [binMsg; zeros(numPaddedBits,1)];
textToEncrypt = bit2int(binMsg,m);

cipherText = gf(zeros(length(textToEncrypt),2),m,poly);

for i = 1:length(textToEncrypt)
    k = randi([1 2^m-2]);
    cipherText(i,:) = [publicKey{1}^k,gf(textToEncrypt(i),m,poly)*publicKey{2}^k];
end

tmp = cipherText.x;
disp(de2char(tmp(:,2),bitsPerChar,m));

decipherText = gf(zeros(size(cipherText,1),1),m,poly);
for i = 1:size(cipherText,1)
    decipherText(i) = cipherText(i,2) * cipherText(i,1)^(-privateKey);
end

disp(de2char(decipherText.x,bitsPerChar,m));

function text = de2char(msg,bitsPerChar,m)
binDecipherText = int2bit(msg,m);
text = char(bit2int(binDecipherText(1:end-mod(numel(binDecipherText),bitsPerChar)),bitsPerChar))';
end