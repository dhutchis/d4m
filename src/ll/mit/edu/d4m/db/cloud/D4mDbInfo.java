package ll.mit.edu.d4m.db.cloud;


import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;

import cloudbase.core.client.BatchScanner;
import java.nio.charset.CharacterCodingException;
import ll.mit.edu.cloud.connection.CloudbaseConnection;
import cloudbase.core.client.CBException;
import cloudbase.core.client.CBSecurityException;
import cloudbase.core.client.TableNotFoundException;
import cloudbase.core.master.MasterNotRunningException;
import java.util.Map.Entry;
import org.apache.hadoop.io.Text;
import cloudbase.core.client.Scanner;
import cloudbase.core.data.Key;
import cloudbase.core.data.Range;
import cloudbase.core.data.Value;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.SortedSet;
import java.util.TreeMap;

/**
 *
 * @author wi20909
 */

public class D4mDbInfo
{


    public D4mDbInfo() {}

    private String host = "localhost";
    private String userName = "root";
    private String password = "secret";
    private String tableName = "";
    private String delimiter = "";

    public String rowReturnString    = "";
    public String columnReturnString = "";
    public String valueReturnString  = "";


    public D4mDbInfo(String host) {
        this.host = host;
    }

    public static void main(String[] args) throws CBException, CBSecurityException, TableNotFoundException {
        if (args.length < 1) {
            return;
        }

        String hostName = args[0];
        D4mDbInfo ci = new D4mDbInfo(hostName);
        String tableList = ci.getTableList();
        System.out.println(tableList);

    }

    public String getTableList() throws CBException, CBSecurityException
    {
        CloudbaseConnection cbConnection = new CloudbaseConnection(this.host, this.userName, this.password);
        SortedSet set = cbConnection.getTableList();
        Iterator it = set.iterator();
        StringBuilder sb = new StringBuilder();
        while(it.hasNext())
        {
            String tableName = (String) it.next();
            sb.append(tableName + " ");
        }
        return sb.toString();
    }

}

