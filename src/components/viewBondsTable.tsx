import React from 'react';
import {
    Button
} from '@chakra-ui/react';
import {
    Table,
    Thead,
    Tbody,
    Tr,
    Th,
    Td,
    TableCaption,
    TableContainer,
  } from '@chakra-ui/react';

interface Props {
  bondName : string,
  totalAmount : number,
  claimableAmount : number
}

const RowData = (props: Props) => {
  return (
    <>
    <Tr>
      <Td>{props.bondName}</Td>
      <Td>{props.totalAmount}</Td>
      <Td>{props.claimableAmount}</Td>
      <Td isNumeric><Button size="sm" borderWidth="0.7px" borderColor="gray.400">View</Button></Td>
  </Tr>
  </>
  )
};




const ViewTable = () => {

    const bonds = [
      {bondName: "test1", totalAmount: 134949},
      {bondName: "test2", totalAmount: 14124244},
      {bondName: "test3", totalAmount: 3534},
      {bondName: "asdfads", totalAmount: 500000}
    ];


    
    
    return (
      <>
<TableContainer mt="5vh" borderWidth="2px" borderColor="grey" width="95%" maxWidth="900px" mx="auto">
  <Table variant='striped' colorScheme="gray">
    <TableCaption>View all available bonds</TableCaption>
    <Thead>
      <Tr>
        <Th>Bond Name</Th>
        <Th>Total amount</Th>
     
        <Th></Th>
      </Tr>
    </Thead>
    <Tbody>
      {bonds.map((bond, key) => {
        return (
          <RowData key={bond.bondName} bondName={bond.bondName} totalAmount={bond.totalAmount}/>
        )
      })}
    </Tbody>
  </Table>
</TableContainer>
        
    
      </>
    )
}

export default ViewTable