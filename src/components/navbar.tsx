import { ReactNode, useState, useEffect } from 'react';
import {
  Box,
  Flex,
  HStack,
  Link,
  Button,
  Menu,
  MenuButton,
  useColorModeValue,
  Stack,
} from '@chakra-ui/react';

import WalletModal from './walletModal';
import { ethers } from "ethers";

const Links = ['View Bonds', 'Buy Bonds', 'Redeem Bonds'];

const NavLink = ({ children }: { children: ReactNode }) => (
  <Link
    px={2}
    py={1}
    rounded={'md'}
    _hover={{
      textDecoration: 'none',
      bg: useColorModeValue('gray.200', 'gray.700'),
    }}
    href={children === 'Redeem Bonds' ? '/redeemBonds' : 'Buy Bonds' ? '/buy' : 'View Bonds' ? './view' : '#'}>
    {children}
  </Link>
);

export default function Navbar() {
  const [modalIsOpen, setIsOpen] = useState(false);
  const [currentAccount, setCurrentAccount] = useState("");
  //const provider = new ethers.providers.Web3Provider(window.ethereum, "any");
  //const signer = provider.getSigner();
  
  useEffect(() => {
    checkIfWalletIsConnected();
    if (window.ethereum) {
      window.ethereum.on("accountsChanged", checkIfWalletIsConnected);
      window.ethereum.on("disconnect", checkIfWalletIsConnected);
    }
    //signer.getAddress().then((address) => {
    //}); 
  }, []);

  function openModal() {
    setIsOpen(true);
  }

  function closeModal() {
    setIsOpen(false);
  }


    //check connected
    const checkIfWalletIsConnected = async () => {
        const { ethereum } = window;
        console.log(currentAccount, "account");
    
        if (!ethereum) {
          //toast("Make sure you have metamask!");
          return;
        }
    
        const accounts = await ethereum.request({ method: "eth_accounts" });
    
        if (accounts.length !== 0) {
          setIsOpen(false);
          const account = accounts[0];
          setCurrentAccount(account);
        } else {
          setCurrentAccount("");
          //toast("No authorized account found");
        }
      };

  const connectWallet = async () => {
    const { ethereum } = window;
    const networkId = await ethereum.request({
      method: "net_version",
    });
    if (networkId === 5) {
      //toast("Make sure you are in polygon network!");
      return;
    }
    const provider = new ethers.providers.Web3Provider(window.ethereum, "any");
    await provider.send("eth_requestAccounts", []);
    const signer = provider.getSigner();
    await signer.getAddress();
  };

  const sliceAddress = (address : string) => {
    return address.slice(0, 6) + "..." + address.slice(38)
  }


  return (
    <>
      <Box bg={useColorModeValue('gray.100', 'gray.900')} px={4}>
        <Flex h={16} alignItems={'center'} justifyContent={'space-between'}>
          <HStack spacing={8} alignItems={'center'}>
            <Box><Link href="./"> Crypto Bonds Project </Link></Box>
            <HStack
              as={'nav'}
              spacing={4}
              display={{ base: 'none', md: 'flex' }}>
                
             
              <Link href='./view'>View Bonds</Link>
              <Link href='./buy'>Buy Bonds</Link>
              <Link href='./redeemBonds'>Redeem Bonds</Link>
            </HStack>
          </HStack>
          <Flex alignItems={'center'}>
            <Menu>
                <div> 
                    {currentAccount ? 
                    <MenuButton
                    as={Button}
                    rounded={'full'}
                    variant={'link'}
                    cursor={'pointer'}
                    minW={0}
                    >
                    Wallet Connected : {sliceAddress(currentAccount)}
                  </MenuButton> : 
                  <MenuButton
                  as={Button}
                  rounded={'full'}
                  variant={'link'}
                  cursor={'pointer'}
                  minW={0}
                  onClick={openModal}
                  >
                  Connect
                </MenuButton>
                    }
                </div>
              
            </Menu>
          </Flex>
        </Flex>

        <WalletModal
        modalIsOpen={modalIsOpen}
        closeModal={closeModal}
        connectWallet = {connectWallet}
        connected = {currentAccount}
      />

      </Box>
    </>
  );
}