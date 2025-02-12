classdef NNI8
    properties
        % Váhy a biasy
        W1
        W2
        W3
        B1
        B2
        B3

        % Výstup
        Vl
        Vr
    end

    methods
        function neunet = NNI8(genotyp)
            Vstupy = 8;
            Vystupy = 2;
            neurony1SkrytejVrstvy = round(Vstupy * 1.5);
            neurony2SkrytejVrstvy = round(Vstupy * 0.5);


            neunet.W1 = reshape(genotyp(1:Vstupy*neurony1SkrytejVrstvy),[neurony1SkrytejVrstvy,Vstupy]);
            neunet.B1 = genotyp(Vstupy*neurony1SkrytejVrstvy+1:Vstupy*neurony1SkrytejVrstvy+neurony1SkrytejVrstvy)';

            %   indexi w2
            ZacW2 = numel(neunet.W1) + numel(neunet.B1) + 1;
            KoncW2 = ZacW2 + neurony1SkrytejVrstvy*neurony2SkrytejVrstvy - 1;

            neunet.W2 = reshape(genotyp(ZacW2:KoncW2),[neurony2SkrytejVrstvy,neurony1SkrytejVrstvy]);
            neunet.B2 = genotyp(KoncW2+1:KoncW2+neurony2SkrytejVrstvy)';

            %     indexi w2
            ZacW3 = KoncW2 + 1 + neurony2SkrytejVrstvy;
            koncW3 = ZacW3 + neurony2SkrytejVrstvy * Vystupy - 1;

            neunet.W3 = reshape(genotyp(ZacW3:koncW3),[Vystupy,neurony2SkrytejVrstvy]);
            neunet.B3 = genotyp(koncW3+1:koncW3 + Vystupy)';

        end
        function [Vl, Vr] = NeuronovaSiet(neunet, input)
            % Vstupy siete
            
            ninput = input / 100;

            X = ninput;
            %Treba prvky ešte normalizovať

            A1 = (neunet.W1*X)+neunet.B1;
            A11 = tanh((1/3)*A1);
            A2=(neunet.W2*A11)+neunet.B2;
            A21=tanh((1/3)*A2);
            A3=(neunet.W3*A21)+neunet.B3;
            A31=tanh((1/3)*A3);

            % Treba denormalizovať

            Vl = A31(1) * 10;
            Vr = A31(2) * 10;

        end
    end
end