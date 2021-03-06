use strict;
use CXGN::Page;
my $page=CXGN::Page->new('cos_markers.html','html2pl converter');
$page->header('Conserved Ortholog Set (COS) markers');
print<<END_HEREDOC;

  <center>
    

    <table summary="" width="720" cellpadding="0" cellspacing="0"
    border="0">
      <tr>
        <td>
          <center>
            <h3>Conserved Ortholog Set (COS) markers</h3>
          </center>

          <p>We have used a computational method to screen the
          tomato EST database against the arabidopsis genome
          sequence in order to find a set of highly conserved,
          single copy genes which can be used as markers for
          comparative mapping between the tomato and arabidopsis
          genomes. Currently we have identified approximately 1000
          of these Conserved Ortholog Set (COS) markers.<br /></p>

          <p>In this section of SGN, you will find sequence and
          clone information for each of these COS markers as well
          as their matching counterpart in the arabidopsis genome.
          We have surveyed these COS markers and mapped some of
          these COS markers on the tomato genome to provide a
          tomato: arabidopsis comparative map. This mapping
          information is available on SGN now.<br /></p>

          <p>Because these COS markers are so highly conserved,
          they may also be useful for comparative mapping in other
          dicot species. The computational screen by how COS
          markers were identified is described below:</p>

          <ul>
            <li>TBLASTX tomato ESTs against the arabidopsis genome
            (specifically, the BAC tiling path from TAIR)</li>

            <li>Identify single best matches (&lt; e -15) between a
            single tomato EST (or associated contig) and a single
            BAC in Arabidopsis. Each tomato EST must pass the
            following criteria:

              <ul>
                <li>it hits an arabidopsis sequence at a
                significance level of &lt; e -15</li>

                <li>it is determined to be NOT part of a domain
                (where several solanaceous sequences hit the same
                arabidopsis region)</li>

                <li>the next best Arabidopsis hit must be of lower
                significance (delta e &gt; 10)</li>
              </ul>
            </li>

            <li>ESTs that pass all these criteria are classified as
            conserved orthologs, all others are considered
            potentially paralogous and eliminated.</li>
          </ul><br />

          <h4>Functional annotation of COS markers</h4>

          <p>COS-markers were functionally annotated using the MIPS
          role categories as they were defined at the time of the
          analysis. As the functional role descriptions are subject
          to continued changes, a copy of the role categories and
          the COS-marker annotations as used in the analysis can be
          found below:<br /></p>

          <p><a href="/documents/markers/role_categories.txt">MIPS role categories at
          time of COS marker annotation</a></p>

          <h4>The list of COS markers is available in both online
          and plain text format</h4>

          <p><a href="/search/markers/cos_list.pl">COS list
          online</a> - online format with links to sequences and
          tiling path.<br />
          <a href="/documents/markers/cos_list-old.txt">Old plain text download</a> - plain
          text format for download. <br />
          <a href="/documents/markers/cos_list.txt">Old plain text download 2</a> - plain
          text format for download. 
          </p>

          <p><strong>Note:</strong> for the tomato map position in
          the table linked above:</p>

          <ul>
            <li>Copy No is how many copies the COS marker shows on
            a southern blot survey- S(single) is 1-2 copy, L(low)
            is 3-4 copy, M(multiple) means more than 4 copy.</li>

            <li>Map position is where the COS marker mapped on the
            tomato: arabidopsis systeny map. For example, T1675 map
            position is 01.005, meaning Chromosome 1, 5 cM down
            from the top. Most of the COS markers have only one map
            position, if the COS marker has a second or third map
            position, then there were two or three alleles that
            could be mapped.</li>
          </ul><br />
          <br />
        </td>
      </tr>
    </table>
    
  </center>
END_HEREDOC
$page->footer();
