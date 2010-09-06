use strict;
use warnings;
use Test::More;

use HTTP::Request::Common;

use lib 't/lib';
use SGN::Test qw/ request /;
BEGIN { use_ok 'SGN::Controller::Project::Secretom::SecreTary' }

ok( request('/secretom/secretary')->is_success, 'Request should succeed' );

my $test_data = <<'';
>AT1G73440.1 AI22=4.545 Gravy22=-1.4545 nR=2 nS=10 nT=0 nDRQPEN=7 Nitrogen=28 Oxygen=42 
MARGESEGESSGSERESSSSSSGNESEPTKGTISKYEKQRLSRIAENKARLDALGISKAAKALLSPSPVSKKRRVKRNSGEEDDDYTPVIADGDGDEDDDEVEEIDEDEEFLCKRKNKSSASKRKVSSRKILNTSVSLGEDDDDLDKAIALSLQGSVAGSDKEAATMKKKRPELMSKTQMTQDELVMYFCQFDEGGKGFITLRDVAKMATVHDFTWTEEELQDMIRCFDMDKDGKLSLDEFRKIVSRCRMLKGS* 
>AT1G75120.1 AI22=119.545 Gravy22=0.5864 nR=2 nS=0 nT=0 nDRQPEN=6 Nitrogen=31 Oxygen=27 
MAVRKEKVQPFRECGIAIAVLVGIFIGCVCTILIPNDFVNFRSSKVASASCESPERVKMFKAEFAIISEKNGELRKQVSDLTEKVRLAEQKEVIKAGPFGTVTGLQTNPTVAPDESANPRLAKLLEKVAVNKEIIVVLANNNVKPMLEVQIASVKRVGIQNYLVVPLDDSLESFCKSNEVAYYKRDPDNAIDVVGKSRRSSDVSGLKFRVLREFLQLGYGVLLSDVDIVFLQNPFGHLYRDSDVESMSDGHDNNTAYGFNDVFDDPTMTRSRTVYTNRIWVFNSGFFYLRPTLPSIELLDRVTDTLSKSGGWDQAVFNQHLFYPSHPGYTGLYASKRVMDVYEFMNSRVLFKTVRKDEEMKKLKPVIIHMNYHSDKLERMQAAVEFYVNGKQDALDRFRDGS* 
>AT1G17600.1 AI22=61.818 Gravy22=-0.2273 nR=2 nS=5 nT=0 nDRQPEN=6 Nitrogen=29 Oxygen=34 
MVSSSAPRVSKYDVFLSFRGEDTRKTIVSHLYAALDSRGIVTFKDDQRLEIGDHISDELHRALGSSSFAVVVLSENYATSRWCLLELQLIMELMKEGRLEVFPIFYGVDPSVVRHQLGSFSLVKYQGLEMVDKVLRWREALNLIANLSGVVSSHCVDEAIMVGEIARDISRRVTLMHKIDSGNIVGMKAHMEGLNHLLDQESNEVLLVGIWGMGGIGKTSIVKCLYDQLSPKFPAHCFIENIKSVSKDNGHDLKHLQKELLSSILCDDIRLWSVEAGCQEIKKRLGNQKVFLVLDGVDKVAQVHALAKEKNWFGPGSRIIITTRDMGLLNTCGVEVVYEVKCLDDKDALQMFKQIAFEGGLPPCEGFDQLSIRASKLAHGLPSAIQAYALFLRGRTASPEEWEEALGALESSLDENIMEILKISYEGLPKPHQNVFLHVVCLFNGDTLQRITSLLHGPIPQSSLWIRVLAEKSLIKISTNGSVIMHKLVEQMGREIIRDDMSLARKFLRDPMEIRVALAFRDGGEQTECMCLHTCDMTCVLSMEASVVGRMHNLKFLKVYKHVDYRESNLQLIPDQPFLPRSLRLFHWDAFPLRALPSGSDPCFLVELNLRHSDLETLWSGTPSNGVKTENPCEKHNSNYFHVLLYLAQMLKSLKRLDVTGSKHLKQLPDLSSITSLEELLLEQCTRLEGIPECIGKRSTLKKLKLSYRGGRRSALRFFLRKSTRQQHIGLEFPDAKVKMDALINISIGGDITFEFRSKFRGYAEYVSFNSEQQIPIISAMSLQQAPWVISECNRFNSLRIMRFSHKENGESFSFDVFPDFPDLKELKLVNLNIRKIPSGICHLDLLEKLDLSGNDFENLPEAMSSLSRLKTLWLQNCFKLQELPKLTQVQTLTLTNCRNLRSLAKLSNTSQDEGRYCLLELCLENCKSVESLSDQLSHFTKLTCLDLSNHDFETLPSSIRDLTSLVTLCLNNCKKLKSVEKLPLSLQFLDAHGCDSLEAGSAEHFEDIPNKEVNTWLLIRLYYD* 
>AT1G51380.1 AI22=84.091 Gravy22=-0.5318 nR=0 nS=0 nT=3 nDRQPEN=7 Nitrogen=26 Oxygen=36 
MEGTLDEENLVFETTKGIKPIKSFDDMGMNDKVLRGVYDYGYKKPSEIQQRALVPILKGRDVIAQAQSGTGKTSMIAISVCQIVNISSRKVQVLVLSPSRELASQTEKTIQAIGAHTNIQAHACIGGKSIGEDIKKLERGVHAVSGTPGRVYDMIKRGSLQTKAVKLLVLDESDEMLSKGLKDQIYDVYRALPHDIQVCLISATLPQEILEMTEKFMTDPVRILVKPDELTLEGIKQYYVDVDKEEWKFDTLCDLYGRLTINQAIIFCNTRQKVDWLTEKMRSSNFIVSSMHGDKRQKERDDIMNQFRSFKSRVLIASDVWARGIDVQTVSHVINYDIPNNPELYIHRIGRAGRFGREGVAINFVKSSDMKDLKDIERHYGTKIREMPADLV* 
>AT1G77370.1 AI22=159.091 Gravy22=1.3318 nR=2 nS=1 nT=0 nDRQPEN=6 Nitrogen=29 Oxygen=28 
MVDQSPRRVVVAALLLFVVLCDLSNSAGAANSVSAFVQNAILSNKIVIFSKSYCPYCLRSKRIFSQLKEEPFVVELDQREDGDQIQYELLEFVGRRTVPQVFVNGKHIGGSDDLGAALESGQLQKLLAAS* 
>AT1G44090.1 AI22=66.364 Gravy22=-0.0773 nR=2 nS=1 nT=2 nDRQPEN=6 Nitrogen=31 Oxygen=28 
MCIYASRQTVCPYLTPFKVKRPKSREMNSSDVNFSLLQSQPNVPAEFFWPEKDVAPSEGDLDLPIIDLSGFLNGNEAETQLAAKAVKKACMAHGTFLVVNHGFKSGLAEKALEISSLFFGLSKDEKLRAYRIPGNISGYTAGHSQRFSSNLPWNETLTLAFKKGPPHVVEDFLTSRLGNHRQEIGQVFQEFCDAMNGLVMDLMELLGISMGLKDRTYYRRFFEDGSGIFRCNYYPPCKQPEKALGVGPHNDPTAITVLLQDDVVGLEVFAAGSWQTVRPRPGALVVNVGDTFMALSNGNYRSCYHRAVVNKEKVRRSLVFFSCPREDKIIVPPPELVEGEEASRKYPDFTWAQLQKFTQSGYRVDNTTLHNFSSWLVSNSDKKST* 

my @test_requests = (
    # simulate a pasted sequence with 
    ( POST '/secretom/secretary/run', [ sequence => $test_data ] ),

    # simulate an uploaded file
    ( POST '/secretom/secretary/run',
      Content_Type => 'form-data',
      Content => [
          sequence_file => [
              undef,
              'test.fasta',
              Content_Type => 'application/octet-stream',
              Content => $test_data,
             ],
         ],
     ),

    # simulate a pasted sequence with sort box checked
    ( POST '/secretom/secretary/run', [ sequence => $test_data, sort => 'Sort by score' ] ),

    # simulate both an uploaded file and a paste, both boxes checked
    ( POST '/secretom/secretary/run',
      Content_Type => 'form-data',
      Content => [
          sequence      => $test_data,
          sequence_file => [
              undef,
              'test.fasta',
              Content_Type => 'application/octet-stream',
              Content => $test_data,
             ],
           sort => 1,
         ],
     ),

   );


foreach my $test_req ( @test_requests ) {
    my $response = request $test_req;

    like( $response->content, qr/(2|4) secreted sequences predicted out of (6|12)/,
          'got correct secreted sequence count' );

    like( $response->content, qr/$_/, "ID $_ appears in output" )
        for qw( AT1G73440.1  AT1G75120.1  AT1G17600.1  AT1G51380.1  AT1G77370.1 AT1G44090.1 );

    like( $response->content, qr/$_\s+YES/, "$_ shows as secreted" )
        for qw( AT1G77370.1  AT1G75120.1 );

    like( $response->content, qr/$_\s+NO/, "$_ shows as NOT secreted" )
        for qw( AT1G73440.1 AT1G17600.1  AT1G51380.1 AT1G44090.1 );
}

done_testing;