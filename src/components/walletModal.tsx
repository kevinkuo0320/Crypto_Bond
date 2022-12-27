import {
    Modal,
    ModalOverlay,
    ModalContent,
    ModalHeader,
    ModalFooter,
    ModalBody,
    ModalCloseButton,
    Button,
  } from '@chakra-ui/react'

  import Image from 'next/image';

function WalletModal({ closeModal, modalIsOpen, connectWallet, connected }) {
    return (
      <>
        <Modal isOpen={modalIsOpen} onClose={closeModal}>
          <ModalOverlay />
          <ModalContent>
            <ModalHeader>Connect to Metamask Wallet</ModalHeader>
            <ModalCloseButton />
            <ModalBody 
                justifyContent={"center"} 
                display="flex">
                <Image src="/metamask.png" 
                height={120}
                width={120}
                alt="metamask_wallet"></Image>
            </ModalBody>
  
            <ModalFooter  justifyContent={"center"} display="flex">
             <Button colorScheme='blue' mr={3} onClick={connectWallet} >
                Connect
              </Button>
            </ModalFooter>
          </ModalContent>
        </Modal>
      </>
    )
  }

  export default WalletModal; 