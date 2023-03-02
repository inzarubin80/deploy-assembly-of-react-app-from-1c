import * as React from 'react';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import { dividerClasses } from '@mui/material';

export const Tasks = () => {
    const [rows, setRows] = React.useState([]);
    const getTasks = async () => {
        const response = await fetch("http://localhost:9000/Portal/hs/content/api/tasks",{method: "GET"});
        if (response.ok) {
            const data = await response.json();
            setRows(data)
        }
    }

    React.useEffect(()=>{
        getTasks();
    },[])

    return (
    <div style={{ maxWidth: 500,   width: "100%"}}>

    <TableContainer component={Paper}>
      <Table sx={{ }} aria-label="simple table">
        <TableHead>
          <TableRow>
            <TableCell align="right">Код</TableCell>
            <TableCell align="right">Наименование</TableCell>

          </TableRow>
        </TableHead>
        <TableBody>
          {rows.map((row) => (
            <TableRow
              key={row.name}
              sx={{ '&:last-child td, &:last-child th': { border: 0 } }}
            >

                <TableCell align="right">
                    {row.code}
                </TableCell>

              <TableCell align="right">
                {row.name}
              </TableCell>
            
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>

    </div>
  );
}