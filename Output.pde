class ArtNetOut extends LXDatagramOutput {

    protected static final String PIXLITE_IP_A = "192.168.69.201";
    protected static final String PIXLITE_IP_B = "192.168.69.202";

    private static final int OUTPUTS_PER_PIXLITE = 16;
    private static final int PIXELS_PER_UNIVERSE = 170;
    HashMap<Integer, List<LXPoint>> outputs = new HashMap();

    ArtNetOut(LX lx) throws IOException {
        super(lx);

        List<Cube> cubes = structure.cubes.cubes;
        List<Diagonal> diags = structure.diagonals.diagonals;
        List<MakerbotGroup> makerbots = structure.makerbots.groups;

        //Pixlite A
        LXFixture[] a_output_1 = {
            cubes.get(1).vertices.get(0),
            cubes.get(1).vertices.get(3)
        };
        LXFixture[] a_output_2 = {
            cubes.get(1).vertices.get(1),
            cubes.get(1).vertices.get(2)
        };
        LXFixture[] a_output_3 = {
            cubes.get(3).vertices.get(1)
        };
        LXFixture[] a_output_4 = {
            cubes.get(3).vertices.get(2)
        };
        LXFixture[] a_output_5 = {
            cubes.get(3).vertices.get(0)
        };
        LXFixture[] a_output_6 = {
            makerbots.get(2)
        };
        LXFixture[] a_output_7 = {
            cubes.get(5).vertices.get(1)
        };
        LXFixture[] a_output_8 = {
            cubes.get(5).vertices.get(2)
        };
        LXFixture[] a_output_9 = {
            cubes.get(5).vertices.get(3)
        };
        LXFixture[] a_output_10 = {
            cubes.get(5).vertices.get(0)
        };
        LXFixture[] a_output_11 = {
            diags.get(3)
        };
        LXFixture[] a_output_12 = {
            diags.get(1)
        };
        LXFixture[] a_output_13 = {
            diags.get(2)
        };
        LXFixture[] a_output_14 = {
            diags.get(0)
        };
        LXFixture[] a_output_15 = {
            makerbots.get(0).output_map.get(0)
        };
        LXFixture[] a_output_16 = {
            cubes.get(3).vertices.get(3)
        };

        //Pixlite B
        LXFixture[] b_output_1 = {
            cubes.get(0).vertices.get(1),
            cubes.get(0).vertices.get(3),
            cubes.get(0).vertices.get(0),
            cubes.get(0).vertices.get(2)
        };
        LXFixture[] b_output_2 = {
            cubes.get(2).vertices.get(2)
        };
        LXFixture[] b_output_3 = {
            cubes.get(2).vertices.get(3)
        };
        LXFixture[] b_output_4 = {
            cubes.get(4).vertices.get(1)
        };
        LXFixture[] b_output_5 = {
            cubes.get(4).vertices.get(3)
        };
        LXFixture[] b_output_6 = {
            cubes.get(4).vertices.get(2)
        };
        LXFixture[] b_output_7 = {
            cubes.get(4).vertices.get(0)
        };
        LXFixture[] b_output_8 = {
            cubes.get(6).vertices.get(1)
        };
        LXFixture[] b_output_9 = {
            cubes.get(6).vertices.get(3)
        };
        LXFixture[] b_output_10 = {
            cubes.get(6).vertices.get(2)
        };
        LXFixture[] b_output_11 = {
            cubes.get(6).vertices.get(0)
        };
        LXFixture[] b_output_12 = {
            makerbots.get(1)
        };
        LXFixture[] b_output_13 = {
            makerbots.get(0).output_map.get(1)
        };
        LXFixture[] b_output_14 = {
            cubes.get(2).vertices.get(0)
        };
        LXFixture[] b_output_15 = {
            cubes.get(2).vertices.get(1)
        };


        LXFixture[][] a_outputs = {
            a_output_1,
            a_output_2,
            a_output_3,
            a_output_4,
            a_output_5,
            a_output_6,
            a_output_7,
            a_output_8,
            a_output_9,
            a_output_10,
            a_output_11,
            a_output_12,
            a_output_13,
            a_output_14,
            a_output_15,
            a_output_16
        };

        LXFixture[][] b_outputs = {
            b_output_1,
            b_output_2,
            b_output_3,
            b_output_4,
            b_output_5,
            b_output_6,
            b_output_7,
            b_output_8,
            b_output_9,
            b_output_10,
            b_output_11,
            b_output_12,
            b_output_13,
            b_output_14,
            b_output_15

        };

        //Adding outputs to a hashmap for the sake of visually testing via the UI
        int iter = -1;
        for(LXFixture[] out : a_outputs){
        	List<LXPoint> points = new ArrayList();
        	for(LXFixture fixture : out){
        		points.addAll(fixture.getPoints());
	        	outputs.put(++iter, points);
        	}
        }
        for(LXFixture[] out : b_outputs){
        	List<LXPoint> points = new ArrayList();
        	for(LXFixture fixture : out){
        		points.addAll(fixture.getPoints());
	        	outputs.put(++iter, points);
        	}
        }

        //Creating datagrams to send packets to controllers
        int iterator = 0;
        for(int i=1;iterator<a_outputs.length;i+=6){
            int[] indexes = getIndices(a_outputs[iterator++]);
            createDatagrams(indexes, i-1, PIXLITE_IP_A);
        }
        iterator = 0;
        for(int i=1;iterator<b_outputs.length;i+=6){
            int[] indexes = getIndices(b_outputs[iterator++]);
            createDatagrams(indexes, i-1+100, PIXLITE_IP_B);
        }
    }
    //Recursively create datagrams that are compliant with DMX protocols
    private void createDatagrams(int[] indexes, int start_universe, String ip_address) throws IOException{
        int[] remainder;
        if(indexes.length>PIXELS_PER_UNIVERSE){
            remainder = new int[indexes.length-PIXELS_PER_UNIVERSE];
        }else{
            remainder = new int[0];
        }
        
        int datagram_length = PIXELS_PER_UNIVERSE;
        if(indexes.length < datagram_length){
            datagram_length = indexes.length;
        }
        int[] for_datagram = new int[datagram_length];
        for(int i=0;i<datagram_length;++i){
            for_datagram[i] = indexes[i];
        }
        addDatagram(new ArtNetDatagram(for_datagram,start_universe).setAddress(ip_address));
        for(int i=datagram_length;i<indexes.length;++i){
            remainder[i-datagram_length] = indexes[i];
        }
        if(remainder.length ==0){
            return;
        }
        createDatagrams(remainder, start_universe+1, ip_address);
    }

    private int[] getIndices(LXFixture[] fixtures){
        ArrayList<LXPoint> points = new ArrayList();
        for(LXFixture fixture : fixtures){
            points.addAll(fixture.getPoints());
        }
        int[] out = new int[points.size()];
        for(int i=0;i<out.length;++i){
            out[i] = points.get(i).index;
        }
        return out;
    }
}